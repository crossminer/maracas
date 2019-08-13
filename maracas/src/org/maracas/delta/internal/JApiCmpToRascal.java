package org.maracas.delta.internal;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.maracas.delta.internal.JApiCmpBuilder.CompatibilityChange;
import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IBool;
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

import japicmp.cmp.JApiCmpArchive;
import japicmp.cmp.JarArchiveComparator;
import japicmp.cmp.JarArchiveComparatorOptions;
import japicmp.model.AbstractModifier;
import japicmp.model.AccessModifier;
import japicmp.model.BridgeModifier;
import japicmp.model.FinalModifier;
import japicmp.model.JApiAnnotation;
import japicmp.model.JApiAnnotationElement;
import japicmp.model.JApiAnnotationElementValue;
import japicmp.model.JApiChangeStatus;
import japicmp.model.JApiClass;
import japicmp.model.JApiClassType;
import japicmp.model.JApiField;
import japicmp.model.JApiImplementedInterface;
import japicmp.model.JApiMethod;
import japicmp.model.JApiClassType.ClassType;
import japicmp.model.JApiCompatibilityChange;
import japicmp.model.JApiException;
import japicmp.model.JApiModifier;
import japicmp.model.JApiModifierBase;
import japicmp.model.JApiParameter;
import japicmp.model.JApiReturnType;
import japicmp.model.JApiSuperclass;
import japicmp.model.JApiType;
import japicmp.model.StaticModifier;
import japicmp.model.SyntheticModifier;
import javassist.CtClass;
import javassist.CtField;
import javassist.CtMember;
import javassist.CtMethod;
import javassist.bytecode.annotation.Annotation;

public class JApiCmpToRascal {

	//-----------------------------------------------
    // Fields
    //-----------------------------------------------
	
	private static final TypeFactory typeFactory = TypeFactory.getInstance();
	private final IValueFactory valueFactory;
	private IEvaluatorContext eval;
	private JApiCmpBuilder builder;
	private final Map<String, IConstructor> modifiers;
	private final Map<String, IConstructor> classTypes;
	private final Map<String, IConstructor> simpleChanges;
	
	
	//-----------------------------------------------
    // Methods
    //-----------------------------------------------
	
	/**
	 * Builds a JApiCmpToRascal object.
	 * 
	 * @param typeStore: Rascal type store
	 * @param valueFactory: Rascal value factory
	 * @param eval: Rascal evaluator
	 */
	public JApiCmpToRascal(TypeStore typeStore, IValueFactory valueFactory, IEvaluatorContext eval) {
		this.valueFactory = valueFactory;
		this.eval = eval;
		this.builder = new JApiCmpSimpleBuilder(typeStore, typeFactory, valueFactory);
		this.modifiers = initializeModifiers();
		this.classTypes = initializeClassTypes();
		this.simpleChanges = initializeSimpleChanges();
	}

	/**
	 * Initializes a map relating modifier names to Rascal modifier
	 * constructors. @see JApiCmpBuilder.
	 * 
	 * @return map with keys as strings and values as Rascal constructors.
	 */
	private final Map<String, IConstructor> initializeModifiers() {
		HashMap<String, IConstructor> modifiers = new HashMap<String, IConstructor>();
		modifiers.put(AbstractModifier.ABSTRACT.name(), builder.buildModifierAbstractCons());
		modifiers.put(AbstractModifier.NON_ABSTRACT.name(), builder.buildModifierNonAbstractCons());
		modifiers.put(BridgeModifier.BRIDGE.name(), builder.buildModifierBridgeCons());
		modifiers.put(BridgeModifier.NON_BRIDGE.name(), builder.buildModifierNonBridgeCons());
		modifiers.put(FinalModifier.FINAL.name(), builder.buildModifierFinalCons());
		modifiers.put(FinalModifier.NON_FINAL.name(), builder.buildModifierNonFinalCons());
		modifiers.put(AccessModifier.PRIVATE.name(), builder.buildModifierPrivateCons());
		modifiers.put(AccessModifier.PUBLIC.name(), builder.buildModifierPublicCons());
		modifiers.put(AccessModifier.PROTECTED.name(), builder.buildModifierProtectedCons());
		modifiers.put(AccessModifier.PACKAGE_PROTECTED.name(), builder.buildModifierPackageProtectedCons());
		modifiers.put(StaticModifier.STATIC.name(), builder.buildModifierStaticCons());
		modifiers.put(StaticModifier.NON_STATIC.name(), builder.buildModifierNonStaticCons());
		modifiers.put(SyntheticModifier.SYNTHETIC.name(), builder.buildModifierSyntheticCons());
		modifiers.put(SyntheticModifier.NON_SYNTHETIC.name(), builder.buildModifierNonSyntheticCons());
		return modifiers;
	}
	
	/**
	 * Initializes a map relating class type names to Rascal class type
	 * constructors. @see JApiCmpBuilder.
	 * 
	 * @return map with keys as strings and values as Rascal constructors.
	 */
	private final Map<String, IConstructor> initializeClassTypes() {
		HashMap<String, IConstructor> classTypes = new HashMap<String, IConstructor>();
		classTypes.put(ClassType.ANNOTATION.name(), builder.buildClassTypeAnnotationCons());
		classTypes.put(ClassType.CLASS.name(), builder.buildClassTypeClassCons());
		classTypes.put(ClassType.ENUM.name(), builder.buildClassTypeEnumCons());
		classTypes.put(ClassType.INTERFACE.name(), builder.buildClassTypeInterfaceCons());
		return classTypes;
	}
	
	/**
	 * Initializes a map relating change status names to simple change 
	 * constructors. @see JApiCmpBuilder.
	 * 
	 * @return map with keys as strings and values as Rascal constructors.
	 */
	private final Map<String, IConstructor> initializeSimpleChanges() {
		HashMap<String, IConstructor> simpleChanges = new HashMap<String, IConstructor>();
		simpleChanges.put(JApiChangeStatus.MODIFIED.name(), builder.buildApiSimpleChangeModifiedCons());
		simpleChanges.put(JApiChangeStatus.NEW.name(), builder.buildApiSimpleChangeNewCons());
		simpleChanges.put(JApiChangeStatus.REMOVED.name(), builder.buildApiSimpleChangeRemovedCons());
		simpleChanges.put(JApiChangeStatus.UNCHANGED.name(), builder.buildApiSimpleChangeUnchangedCons());
		return simpleChanges;
	}
	
	/**
	 * Compares two versions of an API. The source location must point
	 * to two JAR files.
	 * 
	 * @param oldJar: absolute location of the JAR file of the API old 
	 *        version.
	 * @param newJar: absolute location of the JAR file of the API new 
	 *        version.
	 * @param oldVersion: string with the API old version.
	 * @param newVersion: string with the API new version.
	 * @return list of API entities compared between the two API versions 
	 *         (see module org::maracas::delta::JApiCmp). 
	 */
	public IList compare(ISourceLocation oldJar, ISourceLocation newJar, IString oldVersion, IString newVersion) {
		JarArchiveComparatorOptions options = new JarArchiveComparatorOptions();
		JarArchiveComparator comparator = new JarArchiveComparator(options);
		
		JApiCmpArchive oldAPI = new JApiCmpArchive(sourceLocationToFile(oldJar), oldVersion.getValue());
		JApiCmpArchive newAPI = new JApiCmpArchive(sourceLocationToFile(oldJar), newVersion.getValue());
		
		IListWriter result = valueFactory.listWriter();
		List<JApiClass> classes = comparator.compare(oldAPI, newAPI);
		classes.forEach(c -> {
			result.append(translate(c));
		});
		
		return result.done();
	}
	
	/**
	 * Creates a File object from a Rascal source location.
	 * 
	 * @param loc: Rascal source location
	 * @return Java file
	 */
	private File sourceLocationToFile(ISourceLocation loc) {
		String path = loc.getPath();
		return new File(path);
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiClass} to an APIEntity 
	 * class constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param clas: JApiClass to be translated
	 * @return Rascal constructor of an APIEntity class
	 */
	private IConstructor translate(JApiClass clas) {
		JApiChange<CtClass> japiChange = new JApiChange<CtClass>(clas.getOldClass().get(), clas.getNewClass().get(), clas.getChangeStatus());
		
		IString name = valueFactory.string(clas.getFullyQualifiedName());
		IConstructor classType = translate(clas.getClassType());
		IList entities = translateEntities(clas);
		IList changes = translateCompatibilityChanges(clas.getCompatibilityChanges()); 
		IConstructor apiChange = translate(japiChange);
		
		return builder.buildApiEntityClassCons(name, classType, entities, changes, apiChange);
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiClassType} to an APIChange 
	 * constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param classType: JApiClassType to be translated
	 * @return Rascal constructor of an APIChange 
	 */
	private IConstructor translate(JApiClassType classType) {
		JApiChangeStatus changeStatus = classType.getChangeStatus();
		IConstructor oldClassType = classTypes.get(classType.getOldType());
		IConstructor newClassType = classTypes.get(classType.getNewType());
		return buildApiChangeConstructor(builder.getClassTypeType(), oldClassType, newClassType, changeStatus);
	}
	
	/**
	 * Translates a subset of {@link japicmp.model.JApiClass} attributes
	 * to a list of APIEntities (see module org::maracas::delta::JApiCmp).
	 * Modifiers, fields, methods, interfaces, and annotations 
	 * are considered.
	 * 
	 * @param clas: JApiClass to be translated
	 * @return Rascal list with APIEntity constructors
	 */
	private IList translateEntities(JApiClass clas) {		
		IListWriter entitiesWriter = valueFactory.listWriter();
		entitiesWriter.append(translate(clas.getAbstractModifier()));
		entitiesWriter.append(translate(clas.getAccessModifier()));
		entitiesWriter.append(translate(clas.getFinalModifier()));
		entitiesWriter.append(translate(clas.getStaticModifier()));
		entitiesWriter.append(translate(clas.getSyntheticModifier()));
		entitiesWriter.append(translate(clas.getSuperclass()));
		
		List<JApiField> fields = clas.getFields();
		fields.forEach(f -> {
			entitiesWriter.append(translate(f));
		});
		
		List<JApiMethod> methods = clas.getMethods();
		methods.forEach(m -> {
			entitiesWriter.append(translate(m));
		});
		
		List<JApiImplementedInterface> interfaces = clas.getInterfaces();
		interfaces.forEach(i -> {
			entitiesWriter.append(translate(i));
		});
		
		List<JApiAnnotation> annotations = clas.getAnnotations();
		annotations.forEach(a -> {
			entitiesWriter.append(translate(a));
		});
		
		return entitiesWriter.done();
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiSuperclass} to an APIChange 
	 * constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param superclass: JApiSuperclass to be translated
	 * @return Rascal constructor of an APIChange
	 */
	private IConstructor translate(JApiSuperclass superclass) {
		JApiChange<CtClass> superclassChange = new JApiChange<CtClass>(superclass.getOldSuperclass().get(), superclass.getNewSuperclass().get(), superclass.getChangeStatus());
		return translate(superclassChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiImplementedInterface} to an 
	 * APIEntity interface constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param inter: JApiImplementedInterface to be translated
	 * @returnRascal constructor of an APIEntity interface
	 */
	private IConstructor translate(JApiImplementedInterface inter) {
		IString name = valueFactory.string(inter.getFullyQualifiedName());
		IList changes = translateCompatibilityChanges(inter.getCompatibilityChanges());
		IConstructor apiChange = simpleChanges.get(inter.getChangeStatus().name());
		return builder.buildApiEntityInterfaceCons(name, changes, apiChange);
	}

	/**
	 * 
	 * @param method
	 * @return
	 */
	private IConstructor translate(JApiMethod method) {
		JApiChange<CtMethod> japiChange = new JApiChange<CtMethod>(method.getOldMethod().get(), method.getNewMethod().get(), method.getChangeStatus());
		
		IString name = valueFactory.string(method.getName());
		IConstructor returnType = translate(method.getReturnType());
		IList entities = translateEntities(method);
		IList changes = translateCompatibilityChanges(method.getCompatibilityChanges());
		IConstructor apiChange = translate(japiChange);
		
		return builder.buildApiEntityMethodCons(name, returnType, entities, changes, apiChange);
	}

	private IConstructor translate(JApiReturnType returnType) {
		JApiChangeStatus changeStatus = returnType.getChangeStatus();
		IString oldReturnType = valueFactory.string(returnType.getOldReturnType());
		IString newReturnType = valueFactory.string(returnType.getNewReturnType());
		return buildApiChangeConstructor(typeFactory.stringType(), oldReturnType, newReturnType, changeStatus);
	}
	
	private IList translateEntities(JApiMethod method) {
		IListWriter entitiesWriter = valueFactory.listWriter();
		entitiesWriter.append(translate(method.getAbstractModifier()));
		entitiesWriter.append(translate(method.getAccessModifier()));
		entitiesWriter.append(translate(method.getBridgeModifier()));
		entitiesWriter.append(translate(method.getFinalModifier()));
		entitiesWriter.append(translate(method.getStaticModifier()));
		entitiesWriter.append(translate(method.getSyntheticModifier()));
		
		List<JApiParameter> parameters = method.getParameters();
		parameters.forEach(p -> {
			entitiesWriter.append(translate(p));
		});
		
		List<JApiAnnotation> annotations = method.getAnnotations();
		annotations.forEach(a -> {
			entitiesWriter.append(translate(a));
		});
		
		List<JApiException> exceptions = method.getExceptions();
		exceptions.forEach(e -> {
			entitiesWriter.append(translate(e));
		});
		
		return entitiesWriter.done();
	}

	private IConstructor translate(JApiParameter param) {
		IString type = valueFactory.string(param.getType());
		return builder.buildApiEntityParameterCons(type);
	}
	
	private IConstructor translate(JApiException excep) {
		IString name = valueFactory.string(excep.getName());
		IBool checkedException = valueFactory.bool(excep.isCheckedException());
		IConstructor apiChange = simpleChanges.get(excep.getChangeStatus().name());
		return builder.buildApiEntityExceptionCons(name, checkedException, apiChange);
	}

	private IConstructor translate(JApiField field) {
		JApiChange<CtField> japiChange = new JApiChange<CtField>(field.getOldFieldOptional().get(), field.getNewFieldOptional().get(), field.getChangeStatus());

		IString name = valueFactory.string(field.getName());
		IConstructor fieldType = translate(field.getType());
		IList entities = translateEntities(field);
		IList changes = translateCompatibilityChanges(field.getCompatibilityChanges()); 
		IConstructor apiChange = translate(japiChange);
		
		return builder.buildApiEntityFieldCons(name, fieldType, entities, changes, apiChange);
	}

	private IConstructor translate(JApiType type) {
		JApiChangeStatus changeStatus = type.getChangeStatus();
		IString oldType = valueFactory.string(type.getOldValue());
		IString newType = valueFactory.string(type.getNewValue());;
		return buildApiChangeConstructor(typeFactory.stringType(), oldType, newType, changeStatus);
	}
	
	private IList translateEntities(JApiField field) {
		IListWriter entitiesWriter = valueFactory.listWriter();
		
		entitiesWriter.append(translate(field.getAccessModifier()));
		entitiesWriter.append(translate(field.getFinalModifier()));
		entitiesWriter.append(translate(field.getStaticModifier()));
		entitiesWriter.append(translate(field.getSyntheticModifier()));
		entitiesWriter.append(translate(field.getTransientModifier()));
		
		List<JApiAnnotation> annotations = field.getAnnotations();
		annotations.forEach(a -> {
			entitiesWriter.append(translate(a));
		});
		
		return entitiesWriter.done();
	}

	private <T extends JApiModifierBase> IConstructor translate(JApiModifier<T> modifier) {
		JApiChangeStatus changeStatus = modifier.getChangeStatus();
		IConstructor oldModifier = modifiers.get(modifier.getValueOld());
		IConstructor newModifier = modifiers.get(modifier.getValueNew());
		return buildApiChangeConstructor(builder.getModifierType(), oldModifier, newModifier, changeStatus);
	}
	
	private IConstructor translate(JApiAnnotation anno) {
		JApiChange<Annotation> japiChange = new JApiChange<Annotation>(anno.getOldAnnotation().get(), anno.getNewAnnotation().get(), anno.getChangeStatus());
		
		IString name = valueFactory.string(anno.getFullyQualifiedName());
		IConstructor apiChange = translate(japiChange);
		IList entities = translateEntities(anno);
		IList changes = translateCompatibilityChanges(anno.getCompatibilityChanges());
		
		return builder.buildApiEntityAnnotationCons(name, entities, changes, apiChange);
	}

	private IList translateEntities(JApiAnnotation anno) {
		List<JApiAnnotationElement> elements = anno.getElements();
		
		IListWriter entitiesWriter = valueFactory.listWriter();
		elements.forEach(e -> {
			entitiesWriter.append(translate(e));
		});
		
		return entitiesWriter.done();
	}
	
	private IConstructor translate(JApiAnnotationElement annoElem) {		
		IString name = valueFactory.string(annoElem.getName());
		
		IListWriter oldElemsWriter = valueFactory.listWriter();
		List<JApiAnnotationElementValue> oldAnnoElements = annoElem.getOldElementValues();
		oldAnnoElements.forEach(e -> {
			oldElemsWriter.append(valueFactory.string(e.getNameString()));
		});
		
		IListWriter newElemsWriter = valueFactory.listWriter();
		List<JApiAnnotationElementValue> newAnnoElements = annoElem.getNewElementValues();
		newAnnoElements.forEach(e -> {
			newElemsWriter.append(valueFactory.string(e.getNameString()));
		});
		
		JApiChange<IList> japiChange = new JApiChange<IList>(oldElemsWriter.done(), newElemsWriter.done(), annoElem.getChangeStatus());
		IConstructor apiChange = translate(japiChange);
		
		return builder.buildApiEntityAnnotationElementCons(name, apiChange);
	}
	
	private IList translateCompatibilityChanges(List<JApiCompatibilityChange> changes) {		
		IListWriter changesWriter = valueFactory.listWriter();
		changes.forEach(c -> {
			changesWriter.append(translate(c));
		});
		
		return changesWriter.done(); 
	}
	
	private IValue translate(JApiCompatibilityChange change) {
		CompatibilityChange common = builder.createCompatibilityChange();
		common.setBinaryCompatibility(valueFactory.bool(change.isBinaryCompatible()));
		common.setSourceCompatibility(valueFactory.bool(change.isSourceCompatible()));
		
		switch (change) {
		case ANNOTATION_DEPRECATED_ADDED:
			return builder.buildCCAnnotationDeprecatedAddedCons(common);
		case CLASS_LESS_ACCESSIBLE: 
			return builder.buildCCClassLessAccessibleCons(common);
		case CLASS_NO_LONGER_PUBLIC:
			return builder.buildCCClassNoLongerPublicCons(common);
		case CLASS_NOW_ABSTRACT:
			return builder.buildCCClassNowAbstractCons(common);
		case CLASS_NOW_CHECKED_EXCEPTION:
			return builder.buildCCClassNowCheckedExceptionCons(common);
		case CLASS_NOW_FINAL:
			return builder.buildCCClassNowFinalCons(common);
		case CLASS_REMOVED:
			return builder.buildCCClassRemovedCons(common);
		case CLASS_TYPE_CHANGED:
			return builder.buildCCClassTypeChangedCons(common);
		case CONSTRUCTOR_LESS_ACCESSIBLE:
			return builder.buildCCConstructorLessAccessibleCons(common);
		case CONSTRUCTOR_REMOVED:
			return builder.buildCCConstructorRemovedCons(common);
		case FIELD_LESS_ACCESSIBLE:
			return builder.buildCCFieldLessAccessibleCons(common);
		case FIELD_LESS_ACCESSIBLE_THAN_IN_SUPERCLASS:
			return builder.buildCCFieldLessAccessibleThanInSuperclassCons(common);
		case FIELD_NO_LONGER_STATIC:
			return builder.buildCCFieldNoLongerStaticCons(common);
		case FIELD_NOW_FINAL:
			return builder.buildCCFieldNowFinalCons(common);
		case FIELD_NOW_STATIC:
			return builder.buildCCFieldNowStaticCons(common);
		case FIELD_REMOVED:
			return builder.buildCCFieldRemovedCons(common);
		case FIELD_REMOVED_IN_SUPERCLASS:
			return builder.buildCCFieldRemovedInSuperclassCons(common);
		case FIELD_STATIC_AND_OVERRIDES_STATIC:
			return builder.buildCCFieldStaticAndOverridesStaticCons(common);
		case FIELD_TYPE_CHANGED:
			return builder.buildCCFieldTypeChangedCons(common);
		case INTERFACE_ADDED:
			return builder.buildCCInterfaceAddedCons(common);
		case INTERFACE_REMOVED:
			return builder.buildCCInterfaceRemovedCons(common);
		case METHOD_ABSTRACT_ADDED_IN_IMPLEMENTED_INTERFACE:
			return builder.buildCCMethodAbstractAddedInImplementedInterfaceCons(common);
		case METHOD_ABSTRACT_ADDED_IN_SUPERCLASS:
			return builder.buildCCMethodAbstractAddedInSuperclassCons(common);
		case METHOD_ABSTRACT_ADDED_TO_CLASS:
			return builder.buildCCMethodAbstractAddedToClassCons(common);
		case METHOD_ABSTRACT_NOW_DEFAULT:
			return builder.buildCCMethodAbstractNowDefaultCons(common);
		case METHOD_ADDED_TO_INTERFACE:
			return builder.buildCCMethodAddedToInterfaceCons(common);
		case METHOD_IS_STATIC_AND_OVERRIDES_NOT_STATIC:
			return builder.buildCCMethodIsStaticAndOverridesNotStaticCons(common);
		case METHOD_LESS_ACCESSIBLE:
			return builder.buildCCMethodLessAccessibleCons(common);
		case METHOD_LESS_ACCESSIBLE_THAN_IN_SUPERCLASS:
			return builder.buildCCMethodLessAccessibleThanInSuperclassCons(common);
		case METHOD_NEW_DEFAULT:
			return builder.buildCCMethodNewDefaultCons(common);
		case METHOD_NO_LONGER_STATIC:
			return builder.buildCCMethodNoLongerStaticCons(common);
		case METHOD_NOW_ABSTRACT:
			return builder.buildCCMethodNowAbstractCons(common);
		case METHOD_NOW_FINAL:
			return builder.buildCCMethodNowFinalCons(common);
		case METHOD_NOW_STATIC:
			return builder.buildCCMethodNowStaticCons(common);
		case METHOD_NOW_THROWS_CHECKED_EXCEPTION:
			return builder.buildCCMethodNowThrowsCheckedExceptionCons(common);
		case METHOD_REMOVED:
			return builder.buildCCMethodRemovedCons(common);
		case METHOD_REMOVED_IN_SUPERCLASS:
			return builder.buildCCMethodRemovedInSuperclassCons(common);
		case METHOD_RETURN_TYPE_CHANGED:
			return builder.buildCCMethodReturnTypeChangedCons(common);
		case SUPERCLASS_ADDED:
			return builder.buildCCSuperclassAddedCons(common);
		case SUPERCLASS_MODIFIED_INCOMPATIBLE:
			return builder.buildCCSuperclassModifiedIncompatibleCons(common);
		case SUPERCLASS_REMOVED:
			return builder.buildCCSuperclassRemovedCons(common);
		default:
			throw new RuntimeException("The following compatibility change is not supported: " + change.name());
		}
	}
	
	private <T> IConstructor translate(JApiChange<T> apiChange) {
		T elem = apiChange.getOldElem();
		JApiChangeStatus changeStatus = apiChange.getChangeStatus();
		
		if (elem instanceof IList) {
			IList oldElems = ((IList) apiChange.getOldElem());
			IList newElems = ((IList) apiChange.getNewElem());
			return buildApiChangeConstructor(typeFactory.listType(typeFactory.stringType()), oldElems, newElems, changeStatus);
		}
		
		String oldName;
		String newName;
		
		if (elem instanceof Annotation) {
			oldName = ((Annotation) apiChange.getOldElem()).getTypeName();
			newName = ((Annotation) apiChange.getNewElem()).getTypeName();
		}
		else if (elem instanceof CtClass) {
			oldName = ((CtClass) apiChange.getOldElem()).getName();
			newName = ((CtClass) apiChange.getNewElem()).getName();
		}
		else if (elem instanceof CtMember) {
			oldName = ((CtMember) apiChange.getOldElem()).getName();
			newName = ((CtMember) apiChange.getNewElem()).getName();
		}
		else {
			throw new RuntimeException("There was an error with the type of a JApiChange: " + elem.getClass().toString());
		}
		
		IString oldClass = valueFactory.string(oldName);
		IString newClass = valueFactory.string(newName);
		return buildApiChangeConstructor(typeFactory.stringType(), oldClass, newClass, changeStatus);
	}
	
	/**
	 * Builds an APIChange constructor given a type, two elements of 
	 * the corresponding type, and a {@link japicmp.model.JApiChangeStatus}  
	 * (see module org::maracas::delta::JApiCmp).
	 *  
	 * @param type: type of the possibly modified elements
	 * @param oldElem: old element of type {@code type}
	 * @param newElem: new element of type {@code type}
	 * @param changeStatus: change status of the two elements
	 * @return Rascal constructor of an APIChange (i.e. {@code new},
	 *         {@code removed}, {@code unchanged}, and {@code modified})
	 */
	private IConstructor buildApiChangeConstructor(Type type, IValue oldElem, IValue newElem, JApiChangeStatus changeStatus) {
		switch (changeStatus) {
		case MODIFIED: 
			return builder.buildApiChangeModifiedCons(type, oldElem, newElem);
		case NEW:
			return builder.buildApiChangeNewCons(type, newElem);
		case REMOVED:
			return builder.buildApiChangeRemovedCons(type, oldElem);
		case UNCHANGED:
			return builder.buildApiChangeUnchangedCons();
		default:
			throw new RuntimeException("The following change status is not supported: " + changeStatus);
		}
	}
	
	public class JApiChange<T> {
		private T oldElem;
		private T newElem;
		private JApiChangeStatus changeStatus;
		
		public JApiChange(T oldElem, T newElem, JApiChangeStatus changeStatus) {
			this.oldElem = oldElem;
			this.newElem = newElem;
			this.changeStatus = changeStatus;
		}

		public T getOldElem() {
			return oldElem;
		}

		public T getNewElem() {
			return newElem;
		}

		public Class<? extends Object> getType() {
			return oldElem.getClass();
		}
		
		public JApiChangeStatus getChangeStatus() {
			return changeStatus;
		}
	}
}
