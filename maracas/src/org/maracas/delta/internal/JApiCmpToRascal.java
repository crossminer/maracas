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
import japicmp.model.JApiBehavior;
import japicmp.model.JApiChangeStatus;
import japicmp.model.JApiClass;
import japicmp.model.JApiClassType;
import japicmp.model.JApiField;
import japicmp.model.JApiImplementedInterface;
import japicmp.model.JApiMethod;
import japicmp.model.JApiClassType.ClassType;
import japicmp.model.JApiCompatibilityChange;
import japicmp.model.JApiConstructor;
import japicmp.model.JApiException;
import japicmp.model.JApiModifier;
import japicmp.model.JApiModifierBase;
import japicmp.model.JApiParameter;
import japicmp.model.JApiReturnType;
import japicmp.model.JApiSuperclass;
import japicmp.model.JApiType;
import japicmp.model.StaticModifier;
import japicmp.model.SyntheticModifier;

public class JApiCmpToRascal {
	
	//-----------------------------------------------
	// Fields
	//-----------------------------------------------
	
	private static final TypeFactory typeFactory = TypeFactory.getInstance();
	private final IValueFactory valueFactory;
	private IEvaluatorContext eval;
	private JApiCmpBuilder builder;
	private JApiCmpResolver resolver;
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
		this.resolver = new JApiCmpSimpleResolver(valueFactory);
		this.modifiers = initializeModifiers();
		this.classTypes = initializeClassTypes();
		this.simpleChanges = initializeSimpleChanges();
	}

	/**
	 * Initializes a map relating modifier names to Rascal modifier
	 * constructors. @see JApiCmpBuilder.
	 * 
	 * @return map with keys as strings and values as Rascal constructors
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
		JApiCmpArchive newAPI = new JApiCmpArchive(sourceLocationToFile(newJar), newVersion.getValue());
		
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
	 * {@code class} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param clas: JApiClass to be translated
	 * @return Rascal constructor of an APIEntity {@code class}
	 */
	private IConstructor translate(JApiClass clas) {		
		ISourceLocation id = resolver.resolve(clas);
		IConstructor classType = translate(clas.getClassType());
		IList entities = translateEntities(clas);
		IList changes = translateCompatibilityChanges(clas.getCompatibilityChanges()); 
		IConstructor apiChange = simpleChanges.get(clas.getChangeStatus().name());
		
		return builder.buildApiEntityClassCons(id, classType, entities, changes, apiChange);
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiClassType} to an EntityType 
	 * {@code classType} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param classType: JApiClassType to be translated
	 * @return Rascal constructor of an EntityType {@code classType}
	 */
	private IConstructor translate(JApiClassType classType) {
		JApiChangeStatus changeStatus = classType.getChangeStatus();
		IConstructor oldClassType = classTypes.get(classType.getOldType());
		IConstructor newClassType = classTypes.get(classType.getNewType());
		IConstructor apiChange = buildApiChangeConstructor(builder.getClassTypeType(), oldClassType, newClassType, changeStatus);
		
		return builder.buildEntityClassTypeCons(apiChange);
	}
	
	/**
	 * Translates a subset of {@link japicmp.model.JApiClass} attributes
	 * to a list of APIEntities (see module org::maracas::delta::JApiCmp).
	 * Modifiers, fields, constructors, methods, interfaces, and annotations 
	 * are considered.
	 * 
	 * @param clas: target JApiClass
	 * @return Rascal list with APIEntity constructors
	 */
	private IList translateEntities(JApiClass clas) {		
		IListWriter entitiesWriter = valueFactory.listWriter();
		append(clas.getAbstractModifier(), entitiesWriter);
		append(clas.getAccessModifier(), entitiesWriter);
		append(clas.getFinalModifier(), entitiesWriter);
		append(clas.getStaticModifier(), entitiesWriter);
		append(clas.getSyntheticModifier(), entitiesWriter);
		entitiesWriter.append(translate(clas.getSuperclass()));
		
		List<JApiField> fields = clas.getFields();
		fields.forEach(f -> {
			entitiesWriter.append(translate(f));
		});
		
		List<JApiConstructor> constructors = clas.getConstructors();
		constructors.forEach(c -> {
			entitiesWriter.append(translate(c));
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
	 * Trnaslates and appends a Rascal modifier to a list writer based 
	 * on the input {@link japicmp.model.JApiModifier}.
	 * 
	 * @param <T>: type of JApiModifier
	 * @param modifier: modifier to be translated and appended to the 
	 *        list
	 * @param Rascal list writer
	 */
	private <T extends JApiModifierBase> void append(JApiModifier<T> modifier, IListWriter writer) {
		IConstructor oldModifier = modifiers.get(modifier.getValueOld());
		IConstructor newModifier = modifiers.get(modifier.getValueNew());
		
		if (oldModifier != null && newModifier != null) {
			writer.append(translate(modifier));
		}
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiSuperclass} to an APIEntity 
	 * {@code superclass} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param superclass: JApiSuperclass to be translated
	 * @return Rascal constructor of an APIEntity {@code superclass}
	 */
	private IConstructor translate(JApiSuperclass superclass) {
		String oldSuperclass = (superclass.getOldSuperclass().isPresent()) ? superclass.getOldSuperclass().get().getName() : "";
		String newSuperclass = (superclass.getNewSuperclass().isPresent()) ? superclass.getNewSuperclass().get().getName()  : "";
		ISourceLocation oldSuperclassId = resolver.resolveSuperclass(oldSuperclass);
		ISourceLocation newSuperclassId = resolver.resolveSuperclass(newSuperclass);
		IConstructor apiChange = buildApiChangeConstructor(typeFactory.sourceLocationType(), oldSuperclassId, newSuperclassId, superclass.getChangeStatus());
		
		return builder.buildApiEntitySuperclassCons(apiChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiConstructor} to an APIEntity
	 * {@code constructor} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param cons: JApiConstructor to be translated
	 * @return Rascal constructor of an APIEntity {@code constructor}
	 */
	private IValue translate(JApiConstructor cons) {
		ISourceLocation id = resolver.resolve(cons);
		IList entities = translateEntities(cons);
		IList changes = translateCompatibilityChanges(cons.getCompatibilityChanges());
		IConstructor apiChange = simpleChanges.get(cons.getChangeStatus().name());
		
		return builder.buildApiEntityConstructorCons(id, entities, changes, apiChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiImplementedInterface} to an 
	 * APIEntity {@code interface} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param inter: JApiImplementedInterface to be translated
	 * @return Rascal constructor of an APIEntity {@code interface}
	 */
	private IConstructor translate(JApiImplementedInterface inter) {
		ISourceLocation id = resolver.resolve(inter);
		IList changes = translateCompatibilityChanges(inter.getCompatibilityChanges());
		IConstructor apiChange = simpleChanges.get(inter.getChangeStatus().name());
		
		return builder.buildApiEntityInterfaceCons(id, changes, apiChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiMethod} to an APIEntity
	 * {@code method} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param method: JApiMethod to be translated
	 * @return Rascal constructor of an APIEntity {@code method}
	 */
	private IConstructor translate(JApiMethod method) {		
		ISourceLocation id = resolver.resolve(method);
		IConstructor returnType = translate(method.getReturnType());
		IList entities = translateEntities(method);
		IList changes = translateCompatibilityChanges(method.getCompatibilityChanges());
		IConstructor apiChange = simpleChanges.get(method.getChangeStatus().name());
		
		return builder.buildApiEntityMethodCons(id, returnType, entities, changes, apiChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiReturnType} to an EntityType
	 * {@code returnType} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param returnType: JApiReturnType to be translated
	 * @return Rascal constructor of an EntityType {@code returnType}
	 */
	private IConstructor translate(JApiReturnType returnType) {
		String oldReturnType = (!returnType.getOldReturnType().isEmpty()) ? returnType.getOldReturnType() : "";
		String newReturnType = (!returnType.getNewReturnType().isEmpty()) ? returnType.getNewReturnType()  : "";
		ISourceLocation oldReturnTypeLoc = resolver.resolveType(oldReturnType);
		ISourceLocation newReturnTypeLoc = resolver.resolveType(newReturnType);
		IConstructor apiChange = buildApiChangeConstructor(typeFactory.sourceLocationType(), oldReturnTypeLoc, newReturnTypeLoc, returnType.getChangeStatus());
		
		return builder.buildEntityReturnTypeCons(apiChange);
	}
	
	/**
	 * Translates a subset of {@link japicmp.model.JApiBehavior} attributes
	 * to a list of APIEntities (see module org::maracas::delta::JApiCmp).
	 * Modifiers, parameters, annotations, and exceptions are considered.
	 * This method is used by both {@link japicmp.model.JApiMethod} and
	 * {@link japicmp.model.JApiConstructor}.
	 * 
	 * @param method: target JApiBehavior
	 * @return Rascal list with APIEntity constructors
	 */
	private <T extends JApiBehavior> IList translateEntities(T method) {
		IListWriter entitiesWriter = valueFactory.listWriter();
		append(method.getAbstractModifier(), entitiesWriter);
		append(method.getAccessModifier(), entitiesWriter);
		append(method.getBridgeModifier(), entitiesWriter);
		append(method.getFinalModifier(), entitiesWriter);
		append(method.getStaticModifier(), entitiesWriter);
		append(method.getSyntheticModifier(), entitiesWriter);
		
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

	/**
	 * Translates a {@link japicmp.model.JApiParameter} to an APIEntity
	 * {@code parameter} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param param: JApiParameter to be translated
	 * @return Rascal constructor of an APIEntity {@code parameter}
	 */
	private IConstructor translate(JApiParameter param) {
		ISourceLocation type = resolver.resolveType(param);
		return builder.buildApiEntityParameterCons(type);
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiException} to an APIEntity
	 * {@code exception} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param excep: JApiException to be translated
	 * @return Rascal constructor of an APIEntity {@code exception}
	 */
	private IConstructor translate(JApiException excep) {
		ISourceLocation id = resolver.resolve(excep);
		IBool checkedException = valueFactory.bool(excep.isCheckedException());
		IConstructor apiChange = simpleChanges.get(excep.getChangeStatus().name());
		return builder.buildApiEntityExceptionCons(id, checkedException, apiChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiField} to an APIEntity
	 * {@code field} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param field: JApiField to be translated
	 * @return Rascal constructor of an APIEntity {@code field}
	 */
	private IConstructor translate(JApiField field) {
		ISourceLocation id = resolver.resolve(field);
		IConstructor fieldType = translate(field.getType());
		IList entities = translateEntities(field);
		IList changes = translateCompatibilityChanges(field.getCompatibilityChanges()); 
		IConstructor apiChange = simpleChanges.get(field.getChangeStatus().name());;
		
		return builder.buildApiEntityFieldCons(id, fieldType, entities, changes, apiChange);
	}

	/**
	 * Translates a {@link japicmp.model.JApiType} to an EntityType
	 * {@code fieldType} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param type: JApiType to be translated
	 * @return Rascal constructor of an EntityType {@code fieldType}
	 */
	private IConstructor translate(JApiType type) {
		String oldType = (type.getOldTypeOptional().isPresent()) ? type.getOldTypeOptional().get() : "";
		String newType = (type.getNewTypeOptional().isPresent()) ? type.getNewTypeOptional().get()  : "";
		ISourceLocation oldTypeLoc = resolver.resolveType(oldType);
		ISourceLocation newTypeLoc = resolver.resolveType(newType);
		IConstructor apiChange = buildApiChangeConstructor(typeFactory.sourceLocationType(), oldTypeLoc, newTypeLoc, type.getChangeStatus());
		
		return builder.buildEntityFieldTypeCons(apiChange);
	}
	
	/**
	 * Translates a subset of {@link japicmp.model.JApiField} attributes
	 * to a list of APIEntities (see module org::maracas::delta::JApiCmp).
	 * Modifiers and annotations are considered.
	 * 
	 * @param field: target JApiField
	 * @return Rascal list with APIEntity constructors
	 */
	private IList translateEntities(JApiField field) {
		IListWriter entitiesWriter = valueFactory.listWriter();
		
		append(field.getAccessModifier(), entitiesWriter);
		append(field.getFinalModifier(), entitiesWriter);
		append(field.getStaticModifier(), entitiesWriter);
		append(field.getSyntheticModifier(), entitiesWriter);
		append(field.getTransientModifier(), entitiesWriter);

		List<JApiAnnotation> annotations = field.getAnnotations();
		annotations.forEach(a -> {
			entitiesWriter.append(translate(a));
		});
		
		return entitiesWriter.done();
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiModifier} to an APIEntity
	 * {@code modifier} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param <T>: type of JApiModifier
	 * @param modifier: JApiModifier to be translated
	 * @param Rascal constructor of an APIEntity {@code modifier}
	 */
	private <T extends JApiModifierBase> IConstructor translate(JApiModifier<T> modifier) {
		JApiChangeStatus changeStatus = modifier.getChangeStatus();
		IConstructor oldModifier = modifiers.get(modifier.getValueOld());
		IConstructor newModifier = modifiers.get(modifier.getValueNew());
		IConstructor apiChange = buildApiChangeConstructor(builder.getModifierType(), oldModifier, newModifier, changeStatus);
		
		return builder.buildApiEntityModifierCons(apiChange);
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiAnnotation} to an APIEntity
	 * {@code annotation} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param ann: JApiAnnotation to be translated
	 * @return Rascal constructor of an APIEntity {@code annotation}
	 */
	private IConstructor translate(JApiAnnotation ann) {		
		ISourceLocation id = resolver.resolve(ann);
		IList entities = translateEntities(ann);
		IList changes = translateCompatibilityChanges(ann.getCompatibilityChanges());
		IConstructor apiChange = simpleChanges.get(ann.getChangeStatus().name());
				
		return builder.buildApiEntityAnnotationCons(id, entities, changes, apiChange);
	}

	/**
	 * Translates a subset of {@link japicmp.model.JApiAnnotation} attributes
	 * to a list of APIEntities (see module org::maracas::delta::JApiCmp).
	 * Annotation elements are considered.
	 * 
	 * @param ann: target JApiAnnotation
	 * @return Rascal list with APIEntity constructors
	 */
	private IList translateEntities(JApiAnnotation ann) {
		List<JApiAnnotationElement> elements = ann.getElements();
		
		IListWriter entitiesWriter = valueFactory.listWriter();
		elements.forEach(e -> {
			entitiesWriter.append(translate(e));
		});
		
		return entitiesWriter.done();
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiAnnotationElement} to an APIEntity
	 * {@code annotationElement} constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param annoElem: JApiAnnotationElement to be translated
	 * @return Rascal constructor of an APIEntity {@code annotationElement}
	 */
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
		
		IConstructor apiChange = buildApiChangeConstructor(typeFactory.listType(typeFactory.stringType()), oldElemsWriter.done(), newElemsWriter.done(), annoElem.getChangeStatus());
		
		return builder.buildApiEntityAnnotationElementCons(name, apiChange);
	}
	
	/**
	 * Translates a list of {@link japicmp.model.JApiCompatibilityChange} to a
	 * Rascal list of CompatibilityChange constructors (see module 
	 * org::maracas::delta::JApiCmp).
	 * 
	 * @param changes: list of JApiCompatibilityChange to be translated
	 * @return Rascal list with CompatibilityChange constructors
	 */
	private IList translateCompatibilityChanges(List<JApiCompatibilityChange> changes) {		
		IListWriter changesWriter = valueFactory.listWriter();
		changes.forEach(c -> {
			changesWriter.append(translate(c));
		});
		
		return changesWriter.done(); 
	}
	
	/**
	 * Translates a {@link japicmp.model.JApiCompatibilityChange} to a 
	 * CompatibilityChange constructor (see module org::maracas::delta::JApiCmp).
	 * 
	 * @param change: JApiCompatibilityChange to be translated
	 * @return Rascal constructor of a CompatibilityChange
	 */
	private IConstructor translate(JApiCompatibilityChange change) {
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
}
