package org.maracas.delta.internal;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.maracas.delta.internal.JApiCmpBuilder.CompatibilityChange;
import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IListWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.TypeStore;

import japicmp.cmp.JApiCmpArchive;
import japicmp.cmp.JarArchiveComparator;
import japicmp.cmp.JarArchiveComparatorOptions;
import japicmp.model.AbstractModifier;
import japicmp.model.AccessModifier;
import japicmp.model.BridgeModifier;
import japicmp.model.FinalModifier;
import japicmp.model.JApiChangeStatus;
import japicmp.model.JApiClass;
import japicmp.model.JApiClassType;
import japicmp.model.JApiField;
import japicmp.model.JApiClassType.ClassType;
import japicmp.model.JApiCompatibilityChange;
import japicmp.model.JApiModifier;
import japicmp.model.JApiModifierBase;
import japicmp.model.JApiSuperclass;
import japicmp.model.StaticModifier;
import japicmp.model.SyntheticModifier;
import javassist.CtClass;

public class JApiCmpToRascal {

	private final IValueFactory valueFactory;
	private IEvaluatorContext eval;
	private JApiCmpBuilder builder;
	private final Map<String, IConstructor> modifiers;
	private final Map<String, IConstructor> classTypes;
	
	public JApiCmpToRascal(TypeStore typeStore, IValueFactory valueFactory, IEvaluatorContext eval) {
		this.valueFactory = valueFactory;
		this.eval = eval;
		this.builder = new JApiCmpSimpleBuilder(typeStore, valueFactory);
		this.modifiers = initializeModifiers();
		this.classTypes = initializeClassTypes();
	}
	
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
	
	private final Map<String, IConstructor> initializeClassTypes() {
		HashMap<String, IConstructor> classTypes = new HashMap<String, IConstructor>();
		classTypes.put(ClassType.ANNOTATION.name(), builder.buildClassTypeAnnotationCons());
		classTypes.put(ClassType.CLASS.name(), builder.buildClassTypeClassCons());
		classTypes.put(ClassType.ENUM.name(), builder.buildClassTypeEnumCons());
		classTypes.put(ClassType.INTERFACE.name(), builder.buildClassTypeInterfaceCons());
		return classTypes;
	}
	
	public static void main(String[] args) {
		JarArchiveComparatorOptions options = new JarArchiveComparatorOptions();
		JarArchiveComparator comparator = new JarArchiveComparator(options);
		
		JApiCmpArchive oldAPI = new JApiCmpArchive(new File("/Users/ochoa/Desktop/bacata/guava-18.0.jar"), "18.0");
		JApiCmpArchive newAPI = new JApiCmpArchive(new File("/Users/ochoa/Desktop/bacata/guava-19.0.jar"), "19.0");

		List<JApiClass> classes = comparator.compare(oldAPI, newAPI);
		classes.forEach(c -> {
			JApiClassType type = c.getClassType();
			String n = "";
		});
	}
	
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
	
	private File sourceLocationToFile(ISourceLocation loc) {
		String path = loc.getPath();
		return new File(path);
	}
	
	private IConstructor translate(JApiClass clas) {
		JApiChange japiChange = new JApiChange(clas.getOldClass().get(), clas.getNewClass().get(), clas.getChangeStatus());
		
		IString fullyQualifiedName = valueFactory.string(clas.getFullyQualifiedName());
		IConstructor classType = translate(clas.getClassType());
		IList entities = translateClassEntities(clas);
		IList changes = translateClassChanges(clas); 
		IConstructor apiChange = translate(japiChange);
		
		return builder.buildApiEntityClassCons(fullyQualifiedName, classType, entities, changes, apiChange);
	}
	
	private IList translateClassEntities(JApiClass clas) {		
		IListWriter entitiesWriter = valueFactory.listWriter();
		entitiesWriter.append(translate(clas.getAbstractModifier()));
		entitiesWriter.append(translate(clas.getAccessModifier()));
		entitiesWriter.append(translate(clas.getFinalModifier()));
		entitiesWriter.append(translate(clas.getStaticModifier()));
		entitiesWriter.append(translate(clas.getSyntheticModifier()));
		entitiesWriter.append(translate(clas.getSuperclass()));
		
		
		List<JApiField> fields = clas.getFields();
		fields.forEach(f -> {
			//entitiesWriter.append(translate(f));
		});
//		clas.getMethods();
//		clas.getInterfaces();
//		clas.getAnnotations();
		
		return entitiesWriter.done();
	}

	private IList translateClassChanges(JApiClass clas) {
		List<JApiCompatibilityChange> changes = clas.getCompatibilityChanges();
		
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

	//TODO
	private IValue translate(JApiField field) {
		return null;
	}

	private IValue translate(JApiSuperclass superclass) {
		JApiChange superclassChange = new JApiChange(superclass.getOldSuperclass().get(), superclass.getNewSuperclass().get(), superclass.getChangeStatus());
		return translate(superclassChange);
	}

	private <T extends JApiModifierBase> IConstructor translate(JApiModifier<T> modifier) {
		JApiChangeStatus changeStatus = modifier.getChangeStatus();
		IConstructor oldModifier = modifiers.get(modifier.getValueOld());
		IConstructor newModifier = modifiers.get(modifier.getValueNew());
		return getApiChangeConstructor(changeStatus, oldModifier, newModifier);
	}

	private IConstructor translate(JApiClassType classType) {
		JApiChangeStatus changeStatus = classType.getChangeStatus();
		IConstructor oldClassType = classTypes.get(classType.getOldType());
		IConstructor newClassType = classTypes.get(classType.getNewType());
		return getApiChangeConstructor(changeStatus, oldClassType, newClassType);
	}
	
	private IConstructor translate(JApiChange apiChange) {
		JApiChangeStatus changeStatus = apiChange.getChangeStatus();
		IString oldClass = valueFactory.string(apiChange.getOldClass().getName());
		IString newClass = valueFactory.string(apiChange.getNewClass().getName());
		return getApiChangeConstructor(changeStatus, oldClass, newClass);
	}
	
	private IConstructor getApiChangeConstructor(JApiChangeStatus changeStatus, IValue oldElem, IValue newElem) {
		switch (changeStatus) {
		case MODIFIED: 
			return builder.buildApiChangeModifiedCons(builder.getModifierType(), oldElem, newElem);
		case NEW:
			return builder.buildApiChangeNewCons(builder.getModifierType(), newElem);
		case REMOVED:
			return builder.buildApiChangeRemovedCons(builder.getModifierType(), oldElem);
		case UNCHANGED:
			return builder.buildApiChangeUnchangedCons();
		default:
			throw new RuntimeException("The following change status is not supported: " + changeStatus);
		}
	}
	
	public class JApiChange {
		private final CtClass oldClass;
		private final CtClass newClass;
		private final JApiChangeStatus changeStatus;
		
		public JApiChange(CtClass oldClass, CtClass newClass, JApiChangeStatus changeStatus) {
			this.oldClass = oldClass;
			this.newClass = newClass;
			this.changeStatus = changeStatus;
		}

		public CtClass getOldClass() {
			return oldClass;
		}

		public CtClass getNewClass() {
			return newClass;
		}

		public JApiChangeStatus getChangeStatus() {
			return changeStatus;
		}
	}
}
