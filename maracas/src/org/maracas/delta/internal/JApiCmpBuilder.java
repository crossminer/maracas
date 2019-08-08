package org.maracas.delta.internal;

import io.usethesource.vallang.IBool;
import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.type.Type;


public interface JApiCmpBuilder {

	IConstructor buildApiEntityClassCons(IString fullyQualifiedName, IConstructor classType, IList entities, IList changes, IConstructor apiChange);
	IConstructor buildApiEntityInterfaceCons(IString fullyQualifiedName, IConstructor apiChange);
	IConstructor buildApiEntityFieldCons(IInteger name, IString cachedName, IList entities, IList changes, IConstructor apiChange);
	IConstructor buildApiEntityMethodCons(IString name, IConstructor returnType, IList entities, IList changes, IConstructor apiChange);
	IConstructor buildApiEntityConstructorCons(IString name, IList entities, IList changes, IConstructor apiChange);
	IConstructor buildApiEntityAnnotationCons(IString fullyQualifiedName, IList entities, IConstructor apiChange);
	IConstructor buildApiEntityAnnotationElementCons(IString name, IConstructor apiChange);
	IConstructor buildApiEntityExceptionCons(IString name, IBool checkedException, IConstructor apiChange);
	IConstructor buildApiEntityParameterCons(IString type);
	IConstructor buildApiEntityModifierCons(IConstructor apiChange);
	IConstructor buildApiEntitySuperclassCons(IConstructor apiChange);
	IConstructor buildApiChangeNewCons(Type concrete, IValue elem);
	IConstructor buildApiChangeRemovedCons(Type concrete, IValue elem);
	IConstructor buildApiChangeUnchangedCons();
	IConstructor buildApiChangeModifiedCons(Type concrete, IValue oldElem, IValue newElem);
	IConstructor buildApiSimpleChangeNewCons();
	IConstructor buildApiSimpleChangeRemovedCons();
	IConstructor buildApiSimpleChangeUnchangedCons();
	IConstructor buildApiSimpleChangeModifiedCons();
	IConstructor buildEntityClassTypeCons(IConstructor apiChange);
	IConstructor buildEntityReturnTypeCons(IConstructor apiChange);
	IConstructor buildMethodInfoCons(IInteger name, IString cachedName);
	IConstructor buildCCAnnotationDeprecatedAddedCons(CompatibilityChange common);
	IConstructor buildCCClassRemovedCons(CompatibilityChange common);
	IConstructor buildCCClassNowAbstractCons(CompatibilityChange common);
	IConstructor buildCCClassNowFinalCons(CompatibilityChange common);
	IConstructor buildCCClassNoLongerPublicCons(CompatibilityChange common);
	IConstructor buildCCClassTypeChangedCons(CompatibilityChange common);
	IConstructor buildCCClassNowCheckedExceptionCons(CompatibilityChange common);
	IConstructor buildCCClassLessAccessibleCons(CompatibilityChange common);
	IConstructor buildCCSuperclassRemovedCons(CompatibilityChange common);
	IConstructor buildCCSuperclassAddedCons(CompatibilityChange common);
	IConstructor buildCCSuperclassModifiedIncompatibleCons(CompatibilityChange common);
	IConstructor buildCCInterfaceAddedCons(CompatibilityChange common);
	IConstructor buildCCInterfaceRemovedCons(CompatibilityChange common);
	IConstructor buildCCMethodRemovedCons(CompatibilityChange common);
	IConstructor buildCCMethodRemovedInSuperclassCons(CompatibilityChange common);
	IConstructor buildCCMethodLessAccessibleCons(CompatibilityChange common);
	IConstructor buildCCMethodLessAccessibleThanInSuperclassCons(CompatibilityChange common);
	IConstructor buildCCMethodIsStaticAndOverridesNotStaticCons(CompatibilityChange common);
	IConstructor buildCCMethodReturnTypeChangedCons(CompatibilityChange common);
	IConstructor buildCCMethodNowAbstractCons(CompatibilityChange common);
	IConstructor buildCCMethodNowFinalCons(CompatibilityChange common);
	IConstructor buildCCMethodNowStaticCons(CompatibilityChange common);
	IConstructor buildCCMethodNoLongerStaticCons(CompatibilityChange common);
	IConstructor buildCCMethodAddedToInterfaceCons(CompatibilityChange common);
	IConstructor buildCCMethodNowThrowsCheckedExceptionCons(CompatibilityChange common);
	IConstructor buildCCMethodAbstractAddedToClassCons(CompatibilityChange common);
	IConstructor buildCCMethodAbstractAddedInSuperclassCons(CompatibilityChange common);
	IConstructor buildCCMethodAbstractAddedInImplementedInterfaceCons(CompatibilityChange common);
	IConstructor buildCCMethodNewDefaultCons(CompatibilityChange common);
	IConstructor buildCCMethodAbstractNowDefaultCons(CompatibilityChange common);
	IConstructor buildCCFieldStaticAndOverridesStaticCons(CompatibilityChange common);
	IConstructor buildCCFieldLessAccessibleThanInSuperclassCons(CompatibilityChange common);
	IConstructor buildCCFieldNowFinalCons(CompatibilityChange common);
	IConstructor buildCCFieldNowStaticCons(CompatibilityChange common);
	IConstructor buildCCFieldNoLongerStaticCons(CompatibilityChange common);
	IConstructor buildCCFieldTypeChangedCons(CompatibilityChange common);
	IConstructor buildCCFieldRemovedCons(CompatibilityChange common);
	IConstructor buildCCFieldRemovedInSuperclassCons(CompatibilityChange common);
	IConstructor buildCCFieldLessAccessibleCons(CompatibilityChange common);
	IConstructor buildCCConstructorRemovedCons(CompatibilityChange common);
	IConstructor buildCCConstructorLessAccessibleCons(CompatibilityChange common);
	IConstructor buildClassTypeAnnotationCons();
	IConstructor buildClassTypeInterfaceCons();
	IConstructor buildClassTypeClassCons();
	IConstructor buildClassTypeEnumCons();
	IConstructor buildModifierPublicCons();
	IConstructor buildModifierPrivateCons();
	IConstructor buildModifierProtectedCons();
	IConstructor buildModifierPackageProtectedCons();
	IConstructor buildModifierFinalCons();
	IConstructor buildModifierNonFinalCons();
	IConstructor buildModifierStaticCons();
	IConstructor buildModifierNonStaticCons();
	IConstructor buildModifierAbstractCons();
	IConstructor buildModifierNonAbstractCons();
	IConstructor buildModifierSyntheticCons();
	IConstructor buildModifierNonSyntheticCons();
	IConstructor buildModifierBridgeCons();
	IConstructor buildModifierNonBridgeCons();
	
	Type getModifierType();
	
	interface CompatibilityChange {
		void setBinaryCompatibility(IBool compatible);
		void setSourceCompatibility(IBool compatible);
		IBool getBinaryCompatibility();
		IBool getSourceCompatibility();
	}
}
