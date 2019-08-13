package org.maracas.delta.internal;

import java.util.HashMap;
import java.util.Map;

import io.usethesource.vallang.IBool;
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

public class JApiCmpSimpleBuilder implements JApiCmpBuilder {

	private final TypeFactory typeFactory;
	private final TypeStore typeStore;
	private final IValueFactory valueFactory;
	
	// ADTs
	private final Type apiEntityADT;
	private final Type apiChangeADT;
	private final Type apiSimpleChangeADT;
	private final Type entityTypeADT;
	private final Type compatibilityChangeADT;
	private final Type compatibilityChangeTypeADT;
	private final Type classTypeADT;
	private final Type modifierADT;
	
	// Constructors
	private final Type apiEntityClass;
	private final Type apiEntityInterface;
	private final Type apiEntityField;
	private final Type apiEntityMethod;
	private final Type apiEntityConstructor;
	private final Type apiEntityAnnotation;
	private final Type apiEntityAnnotationElement;
	private final Type apiEntityException;
	private final Type apiEntityParameter;
	private final Type apiEntityModifier;
	private final Type apiEntitySuperclass;
	private final Type apiChangeNew;
	private final Type apiChangeRemoved;
	private final Type apiChangeUnchanged;
	private final Type apiChangeModified;
	private final Type apiSimpleChangeNew;
	private final Type apiSimpleChangeRemoved;
	private final Type apiSimpleChangeUnchanged;
	private final Type apiSimpleChangeModified;
	private final Type entityTypeClass;
	private final Type entityTypeField;
	private final Type entityTypeReturn;
	private final Type ccAnnotationDeprecatedAdded;
	private final Type ccClassRemoved;
	private final Type ccClassNowAbstract;
	private final Type ccClassNowFinal;
	private final Type ccClassNoLongerPublic;
	private final Type ccClassTypeChanged;
	private final Type ccClassNowCheckedException;
	private final Type ccClassLessAccessible;
	private final Type ccSuperclassRemoved;
	private final Type ccSuperclassAdded;
	private final Type ccSuperclassModifiedIncompatible;
	private final Type ccInterfaceAdded;
	private final Type ccInterfaceRemoved;
	private final Type ccMethodRemoved;
	private final Type ccMethodRemovedInSuperclass;
	private final Type ccMethodLessAccessible;
	private final Type ccMethodLessAccessibleThanInSuperclass;
	private final Type ccMethodIsStaticAndOverridesNotStatic;
	private final Type ccMethodReturnTypeChanged;
	private final Type ccMethodNowAbstract;
	private final Type ccMethodNowFinal;
	private final Type ccMethodNowStatic;
	private final Type ccMethodNoLongerStatic;
	private final Type ccMethodAddedToInterface;
	private final Type ccMethodNowThrowsCheckedException;
	private final Type ccMethodAbstractAddedToClass;
	private final Type ccMethodAbstractAddedInSuperclass;
	private final Type ccMethodAbstractAddedInImplementedInterface;
	private final Type ccMethodNewDefault;
	private final Type ccMethodAbstractNowDefault;
	private final Type ccFieldStaticAndOverridesStatic;
	private final Type ccFieldLessAccessibleThanInSuperclass;
	private final Type ccFieldNowFinal;
	private final Type ccFieldNowStatic;
	private final Type ccFieldNoLongerStatic;
	private final Type ccFieldTypeChanged;
	private final Type ccFieldRemoved;
	private final Type ccFieldRemovedInSuperclass;
	private final Type ccFieldLessAccessible;
	private final Type ccConstructorRemoved;
	private final Type ccConstructorLessAccessible;
	private final Type classTypeAnnotation;
	private final Type classTypeInterface;
	private final Type classTypeClass;
	private final Type classTypeEnum;
	private final Type modifierPublic;
	private final Type modifierPrivate;
	private final Type modifierProtected;
	private final Type modifierPackageProtected;
	private final Type modifierFinal;
	private final Type modifierNonFinal;
	private final Type modifierStatic;
	private final Type modifierNonStatic;
	private final Type modifierAbstract;
	private final Type modifierNonAbstract;
	private final Type modifierSynthetic;
	private final Type modifierNonSynthetic;
	private final Type modifierBridge;
	private final Type modifierNonBridge;
	
	public JApiCmpSimpleBuilder(TypeStore typeStore, TypeFactory typeFactory, IValueFactory valueFactory) {
		this.typeStore = typeStore;
		this.typeFactory = typeFactory;
		this.valueFactory = valueFactory;
		
		// ADTs
		this.apiEntityADT = typeFactory.abstractDataType(typeStore, "APIEntity");
		this.apiChangeADT = typeFactory.abstractDataType(typeStore, "APIChange", typeFactory.parameterType("T"));
		this.apiSimpleChangeADT = typeFactory.abstractDataType(typeStore, "APIChangeStatus");
		this.entityTypeADT = typeFactory.abstractDataType(typeStore, "EntityType");
		this.compatibilityChangeADT = typeFactory.abstractDataType(typeStore, "CompatibilityChange");
		this.compatibilityChangeTypeADT = typeFactory.abstractDataType(typeStore, "CompatibilityChangeType");
		this.classTypeADT = typeFactory.abstractDataType(typeStore, "ClassType");
		this.modifierADT = typeFactory.abstractDataType(typeStore, "Modifier");
		
		// Constructors
		this.apiEntityClass = typeFactory.constructor(typeStore, apiEntityADT, "class", typeFactory.stringType(), entityTypeADT, typeFactory.listType(apiEntityADT), typeFactory.listType(compatibilityChangeADT), apiChangeADT);
		this.apiEntityInterface = typeFactory.constructor(typeStore, apiEntityADT, "interface", typeFactory.stringType(), apiSimpleChangeADT);
		this.apiEntityField = typeFactory.constructor(typeStore, apiEntityADT, "field", typeFactory.integerType(), typeFactory.stringType(), typeFactory.listType(apiEntityADT), typeFactory.listType(compatibilityChangeADT), apiSimpleChangeADT);
		this.apiEntityMethod = typeFactory.constructor(typeStore, apiEntityADT, "method", typeFactory.stringType(), entityTypeADT, typeFactory.listType(apiEntityADT), typeFactory.listType(compatibilityChangeADT), apiSimpleChangeADT);
		this.apiEntityConstructor = typeFactory.constructor(typeStore, apiEntityADT, "constructor", typeFactory.stringType(), typeFactory.listType(apiEntityADT), typeFactory.listType(compatibilityChangeADT), apiChangeADT);
		this.apiEntityAnnotation = typeFactory.constructor(typeStore, apiEntityADT, "annotation", typeFactory.stringType(), typeFactory.listType(apiEntityADT), apiChangeADT);
		this.apiEntityAnnotationElement = typeFactory.constructor(typeStore, apiEntityADT, "annotationElement", typeFactory.stringType(), apiChangeADT);
		this.apiEntityException = typeFactory.constructor(typeStore, apiEntityADT, "exception", typeFactory.stringType(), typeFactory.boolType(), apiSimpleChangeADT);
		this.apiEntityParameter = typeFactory.constructor(typeStore, apiEntityADT, "parameter", typeFactory.stringType());
		this.apiEntityModifier = typeFactory.constructor(typeStore, apiEntityADT, "modifier", apiChangeADT);
		this.apiEntitySuperclass = typeFactory.constructor(typeStore, apiEntityADT, "superclass", apiChangeADT);
		this.apiChangeNew = typeFactory.constructor(typeStore, apiChangeADT, "new", typeFactory.parameterType("T"));
		this.apiChangeRemoved = typeFactory.constructor(typeStore, apiChangeADT, "removed", typeFactory.parameterType("T"));
		this.apiChangeUnchanged = typeFactory.constructor(typeStore, apiChangeADT, "unchanged");
		this.apiChangeModified = typeFactory.constructor(typeStore, apiChangeADT, "modified", typeFactory.parameterType("T"), typeFactory.parameterType("T"));
		this.apiSimpleChangeNew = typeFactory.constructor(typeStore, apiChangeADT, "new");
		this.apiSimpleChangeRemoved = typeFactory.constructor(typeStore, apiChangeADT, "removed");
		this.apiSimpleChangeUnchanged = typeFactory.constructor(typeStore, apiChangeADT, "unchanged");
		this.apiSimpleChangeModified = typeFactory.constructor(typeStore, apiChangeADT, "modified");
		this.entityTypeClass = typeFactory.constructor(typeStore, entityTypeADT, "classType", apiChangeADT);
		this.entityTypeField = typeFactory.constructor(typeStore, entityTypeADT, "fieldType", apiChangeADT);
		this.entityTypeReturn = typeFactory.constructor(typeStore, entityTypeADT, "returnType", apiChangeADT);
		this.ccAnnotationDeprecatedAdded = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "annotationDeprecatedAdded");
		this.ccClassRemoved = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classRemoved");
		this.ccClassNowAbstract = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classNowAbstract");
		this.ccClassNowFinal = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classNowFinal");
		this.ccClassNoLongerPublic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classNoLongerPublic");
		this.ccClassTypeChanged = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classTypeChanged");
		this.ccClassNowCheckedException = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classNowCheckedException");
		this.ccClassLessAccessible = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "classLessAccessible");
		this.ccSuperclassRemoved = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "superclassRemoved");
		this.ccSuperclassAdded = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "superclassAdded");
		this.ccSuperclassModifiedIncompatible = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "superclassModifiedIncompatible");
		this.ccInterfaceAdded = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "interfaceAdded");
		this.ccInterfaceRemoved = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "interfaceRemoved");
		this.ccMethodRemoved = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodRemoved");
		this.ccMethodRemovedInSuperclass = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodRemovedInSuperclass");
		this.ccMethodLessAccessible = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodLessAccessible");
		this.ccMethodLessAccessibleThanInSuperclass = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodLessAccessibleThanInSuperclass");
		this.ccMethodIsStaticAndOverridesNotStatic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodIsStaticAndOverridesNotStatic");
		this.ccMethodReturnTypeChanged = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodReturnTypeChanged");
		this.ccMethodNowAbstract = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodNowAbstract");
		this.ccMethodNowFinal = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodNowFinal");
		this.ccMethodNowStatic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodNowStatic");
		this.ccMethodNoLongerStatic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodNoLongerStatic");
		this.ccMethodAddedToInterface = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodAddedToInterface");
		this.ccMethodNowThrowsCheckedException = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodNowThrowsCheckedException");
		this.ccMethodAbstractAddedToClass = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodAbstractAddedToClass");
		this.ccMethodAbstractAddedInSuperclass = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodAbstractAddedInSuperclass");
		this.ccMethodAbstractAddedInImplementedInterface = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodAbstractAddedInImplementedInterface");
		this.ccMethodNewDefault = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodNewDefault");
		this.ccMethodAbstractNowDefault = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "methodAbstractNowDefault");
		this.ccFieldStaticAndOverridesStatic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldStaticAndOverridesStatic");
		this.ccFieldLessAccessibleThanInSuperclass = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldLessAccessibleThanInSuperclass");
		this.ccFieldNowFinal = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldNowFinal");
		this.ccFieldNowStatic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldNowStatic");
		this.ccFieldNoLongerStatic = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldNoLongerStatic");
		this.ccFieldTypeChanged = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldTypeChanged");
		this.ccFieldRemoved = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldRemoved");
		this.ccFieldRemovedInSuperclass = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldRemovedInSuperclass");
		this.ccFieldLessAccessible = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "fieldLessAccessible");
		this.ccConstructorRemoved = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "constructorRemoved");
		this.ccConstructorLessAccessible = typeFactory.constructor(typeStore, compatibilityChangeTypeADT, "constructorLessAccessible");
		this.classTypeAnnotation = typeFactory.constructor(typeStore, classTypeADT, "annotation");
		this.classTypeInterface = typeFactory.constructor(typeStore, classTypeADT, "interface");
		this.classTypeClass = typeFactory.constructor(typeStore, classTypeADT, "class");
		this.classTypeEnum = typeFactory.constructor(typeStore, classTypeADT, "enum");
		this.modifierPublic = typeFactory.constructor(typeStore, modifierADT, "public");
		this.modifierPrivate = typeFactory.constructor(typeStore, modifierADT, "private");
		this.modifierProtected = typeFactory.constructor(typeStore, modifierADT, "protected");
		this.modifierPackageProtected = typeFactory.constructor(typeStore, modifierADT, "packageProtected");
		this.modifierFinal = typeFactory.constructor(typeStore, modifierADT, "final");
		this.modifierNonFinal = typeFactory.constructor(typeStore, modifierADT, "nonFinal");
		this.modifierStatic = typeFactory.constructor(typeStore, modifierADT, "static");
		this.modifierNonStatic = typeFactory.constructor(typeStore, modifierADT, "nonStatic");
		this.modifierAbstract = typeFactory.constructor(typeStore, modifierADT, "abstract");
		this.modifierNonAbstract = typeFactory.constructor(typeStore, modifierADT, "nonAbstract");
		this.modifierSynthetic = typeFactory.constructor(typeStore, modifierADT, "synthetic");
		this.modifierNonSynthetic = typeFactory.constructor(typeStore, modifierADT, "nonSynthetic");
		this.modifierBridge = typeFactory.constructor(typeStore, modifierADT, "bridge");
		this.modifierNonBridge = typeFactory.constructor(typeStore, modifierADT, "nonBridge");
	}

	@Override
	public IConstructor buildApiEntityClassCons(IString fullyQualifiedName, IConstructor type, IList entities,
			IList changes, IConstructor apiChange) {
		return valueFactory.constructor(apiEntityClass, fullyQualifiedName, type, entities, changes, apiChange);
	}

	@Override
	public IConstructor buildApiEntityInterfaceCons(IString fullyQualifiedName, IList changes, IConstructor apiChange) {
		return valueFactory.constructor(apiEntityInterface, fullyQualifiedName, changes, apiChange);
	}

	@Override
	public IConstructor buildApiEntityFieldCons(IString name, IConstructor type, IList entities,
			IList changes, IConstructor apiChange) {
		return valueFactory.constructor(apiEntityField, name, type, entities, changes, apiChange);
	}

	@Override
	public IConstructor buildApiEntityMethodCons(IString name, IConstructor returnType, IList entities,
			IList changes, IConstructor apiChange) {
		return valueFactory.constructor(apiEntityMethod, name, returnType, entities, changes, apiChange);
	}

	@Override
	public IConstructor buildApiEntityConstructorCons(IString name, IList entities, IList changes,
			IConstructor apiChange) {
		return valueFactory.constructor(apiEntityConstructor, name, entities, changes, apiChange);
	}

	@Override
	public IConstructor buildApiEntityAnnotationCons(IString fullyQualifiedName, IList entities, IList changes, 
			IConstructor apiChange) {
		return valueFactory.constructor(apiEntityAnnotation, fullyQualifiedName, entities, changes, apiChange);
	}

	@Override
	public IConstructor buildApiEntityAnnotationElementCons(IString name, IConstructor apiChange) {
		return valueFactory.constructor(apiEntityAnnotationElement, name, apiChange);
	}

	@Override
	public IConstructor buildApiEntityExceptionCons(IString name, IBool checkedException, IConstructor apiChange) {
		return valueFactory.constructor(apiEntityException, name, checkedException, apiChange);
	}

	@Override
	public IConstructor buildApiEntityParameterCons(IString type) {
		return valueFactory.constructor(apiEntityParameter, type);
	}

	@Override
	public IConstructor buildApiEntityModifierCons(IConstructor apiChange) {
		return valueFactory.constructor(apiEntityModifier, apiChange);
	}

	@Override
	public IConstructor buildApiEntitySuperclassCons(IConstructor apiChange) {
		return valueFactory.constructor(apiEntitySuperclass, apiChange);
	}

	@Override
	public IConstructor buildApiChangeNewCons(Type concrete, IValue elem) {
		Map<Type, Type> binding = new HashMap<Type, Type>();
		binding.put(typeFactory.parameterType("T"), concrete);
		Type apiChangeNewBound = apiChangeNew.instantiate(binding);
		return valueFactory.constructor(apiChangeNewBound, elem);
	}

	@Override
	public IConstructor buildApiChangeRemovedCons(Type concrete, IValue elem) {
		Map<Type, Type> binding = new HashMap<Type, Type>();
		binding.put(typeFactory.parameterType("T"), concrete);
		Type apiChangeRemovedBound = apiChangeRemoved.instantiate(binding);
		return valueFactory.constructor(apiChangeRemovedBound, elem);
	}

	@Override
	public IConstructor buildApiChangeUnchangedCons() {
		return valueFactory.constructor(apiChangeUnchanged);
	}

	@Override
	public IConstructor buildApiChangeModifiedCons(Type concrete, IValue oldElem, IValue newElem) {
		Map<Type, Type> binding = new HashMap<Type, Type>();
		binding.put(typeFactory.parameterType("T"), concrete);
		Type apiChangeModifiedBound = apiChangeModified.instantiate(binding);
		return valueFactory.constructor(apiChangeModifiedBound, oldElem, newElem);
	}

	@Override
	public IConstructor buildApiSimpleChangeNewCons() {
		return valueFactory.constructor(apiSimpleChangeNew);
	}

	@Override
	public IConstructor buildApiSimpleChangeRemovedCons() {
		return valueFactory.constructor(apiSimpleChangeRemoved);
	}

	@Override
	public IConstructor buildApiSimpleChangeUnchangedCons() {
		return valueFactory.constructor(apiSimpleChangeUnchanged);
	}

	@Override
	public IConstructor buildApiSimpleChangeModifiedCons() {
		return valueFactory.constructor(apiSimpleChangeModified);
	}

	@Override
	public IConstructor buildEntityClassTypeCons(IConstructor apiChange) {
		return valueFactory.constructor(entityTypeClass, apiChange);
	}
	
	@Override
	public IConstructor buildEntityFieldTypeCons(IConstructor apiChange) {
		return valueFactory.constructor(entityTypeField, apiChange);
	}

	@Override
	public IConstructor buildEntityReturnTypeCons(IConstructor apiChange) {
		return valueFactory.constructor(entityTypeReturn, apiChange);
	}

	@Override
	public IConstructor buildCCAnnotationDeprecatedAddedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccAnnotationDeprecatedAdded);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassRemovedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassRemoved);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassNowAbstractCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassNowAbstract);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassNowFinalCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassNowFinal);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassNoLongerPublicCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassNoLongerPublic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassTypeChangedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassTypeChanged);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassNowCheckedExceptionCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassNowCheckedException);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCClassLessAccessibleCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccClassLessAccessible);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCSuperclassRemovedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccSuperclassRemoved);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCSuperclassAddedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccSuperclassAdded);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCSuperclassModifiedIncompatibleCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccSuperclassModifiedIncompatible);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCInterfaceAddedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccInterfaceAdded);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCInterfaceRemovedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccInterfaceRemoved);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodRemovedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodRemoved);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodRemovedInSuperclassCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodRemovedInSuperclass);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodLessAccessibleCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodLessAccessible);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodLessAccessibleThanInSuperclassCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodLessAccessibleThanInSuperclass);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodIsStaticAndOverridesNotStaticCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodIsStaticAndOverridesNotStatic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodReturnTypeChangedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodReturnTypeChanged);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodNowAbstractCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodNowAbstract);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodNowFinalCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodNowFinal);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodNowStaticCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodNowStatic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodNoLongerStaticCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodNoLongerStatic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodAddedToInterfaceCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodAddedToInterface);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodNowThrowsCheckedExceptionCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodNowThrowsCheckedException);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodAbstractAddedToClassCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodAbstractAddedToClass);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodAbstractAddedInSuperclassCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodAbstractAddedInSuperclass);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodAbstractAddedInImplementedInterfaceCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodAbstractAddedInImplementedInterface);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodNewDefaultCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodNewDefault);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCMethodAbstractNowDefaultCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccMethodAbstractNowDefault);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldStaticAndOverridesStaticCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldStaticAndOverridesStatic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldLessAccessibleThanInSuperclassCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldLessAccessibleThanInSuperclass);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldNowFinalCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldNowFinal);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldNowStaticCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldNowStatic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldNoLongerStaticCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldNoLongerStatic);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldTypeChangedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldTypeChanged);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldRemovedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldRemoved);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldRemovedInSuperclassCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldRemovedInSuperclass);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCFieldLessAccessibleCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccFieldLessAccessible);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCConstructorRemovedCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccConstructorRemoved);
		return apply(common, change);
	}

	@Override
	public IConstructor buildCCConstructorLessAccessibleCons(CompatibilityChange common) {
		IConstructor change = valueFactory.constructor(ccConstructorLessAccessible);
		return apply(common, change);
	}

	@Override
	public IConstructor buildClassTypeAnnotationCons() {
		return valueFactory.constructor(classTypeAnnotation);
	}

	@Override
	public IConstructor buildClassTypeInterfaceCons() {
		return valueFactory.constructor(classTypeInterface);
	}

	@Override
	public IConstructor buildClassTypeClassCons() {
		return valueFactory.constructor(classTypeClass);
	}

	@Override
	public IConstructor buildClassTypeEnumCons() {
		return valueFactory.constructor(classTypeEnum);
	}

	@Override
	public IConstructor buildModifierPublicCons() {
		return valueFactory.constructor(modifierPublic);
	}

	@Override
	public IConstructor buildModifierPrivateCons() {
		return valueFactory.constructor(modifierPrivate);
	}

	@Override
	public IConstructor buildModifierProtectedCons() {
		return valueFactory.constructor(modifierProtected);
	}

	@Override
	public IConstructor buildModifierPackageProtectedCons() {
		return valueFactory.constructor(modifierPackageProtected);
	}

	@Override
	public IConstructor buildModifierFinalCons() {
		return valueFactory.constructor(modifierFinal);
	}

	@Override
	public IConstructor buildModifierNonFinalCons() {
		return valueFactory.constructor(modifierNonFinal);
	}

	@Override
	public IConstructor buildModifierStaticCons() {
		return valueFactory.constructor(modifierStatic);
	}

	@Override
	public IConstructor buildModifierNonStaticCons() {
		return valueFactory.constructor(modifierNonStatic);
	}

	@Override
	public IConstructor buildModifierAbstractCons() {
		return valueFactory.constructor(modifierAbstract);
	}

	@Override
	public IConstructor buildModifierNonAbstractCons() {
		return valueFactory.constructor(modifierNonAbstract);
	}

	@Override
	public IConstructor buildModifierSyntheticCons() {
		return valueFactory.constructor(modifierSynthetic);
	}

	@Override
	public IConstructor buildModifierNonSyntheticCons() {
		return valueFactory.constructor(modifierNonSynthetic);
	}

	@Override
	public IConstructor buildModifierBridgeCons() {
		return valueFactory.constructor(modifierBridge);
	}

	@Override
	public IConstructor buildModifierNonBridgeCons() {
		return valueFactory.constructor(modifierNonBridge);
	}

	@Override
	public Type getModifierType() {
		return modifierADT;
	}
	
	@Override
	public Type getClassTypeType() {
		return classTypeADT;
	}
	
	private IConstructor apply(CompatibilityChange common, IConstructor change) {
		change = change.asWithKeywordParameters().setParameter("binaryCompatibility", common.getBinaryCompatibility());
		change = change.asWithKeywordParameters().setParameter("sourceCompatibility", common.getSourceCompatibility());
		return change;
	}

	@Override
	public CompatibilityChange createCompatibilityChange() {
		return new SimpleCompatibilityChange();
	}
	
	public class SimpleCompatibilityChange implements CompatibilityChange {
		
		private IBool binaryCompatibility;
		private IBool sourceCompatibility;
		
		public SimpleCompatibilityChange(IBool binaryCompatibility, IBool sourceCompatibility) {
			this.binaryCompatibility = binaryCompatibility;
			this.sourceCompatibility = sourceCompatibility;
		}
		
		public SimpleCompatibilityChange() {
			this.binaryCompatibility = valueFactory.bool(false);
			this.sourceCompatibility = valueFactory.bool(false);
		}
				
		@Override
		public void setBinaryCompatibility(IBool compatible) {
			this.binaryCompatibility = compatible;
		}

		@Override
		public void setSourceCompatibility(IBool compatible) {
			this.sourceCompatibility = compatible;
		}

		@Override
		public IBool getBinaryCompatibility() {
			return this.binaryCompatibility;
		}

		@Override
		public IBool getSourceCompatibility() {
			return this.sourceCompatibility;
		}
		
	}
}
