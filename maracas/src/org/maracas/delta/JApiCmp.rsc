module org::maracas::delta::JApiCmp

import lang::java::m3::AST;

data APIEntity
	= class(str className, //fullyQualifiedName
	    EntityType classType, 
	    list[APIEntity] classEntities,
	    list[CompatibilityChange] classChanges,
	    APIChange[str] classChange)
	| interface(str interName, APISimpleChange interChange) //fullyQualifiedName
	| field(int fieldName,
		str fieldCachedName,
		list[APIEntity] fieldEntities, 
		list[CompatibilityChange] fieldChanges,
		APISimpleChange fieldChange)
	| method(str methName, 
		EntityType returnType,
		list[APIEntity] methEntities,
		list[CompatibilityChange] methChanges,
		APIChange[MethodInfo] methChange)
	| constructor(str consName, 
		list[APIEntity] consEntities,
		list[CompatibilityChange] consChanges,
		APIChange[MethodInfo] consChange)
	| annotation(str annName, //fullyQualifiedName
		list[APIEntity] annEntities,
		APIChange[int] annChange)
	| annotationElement(str annElemName, APIChange[str] annElemChange)
	| exception(str excepName, bool checkedException, APISimpleChange excepChange)
	| parameter(str \type)
	| modifier(APIChange[Modifier] modifChange)
	| superclass(APIChange[str] superChange) // Qualified names are considered
	;   

data APIChange[&T]
	= new(&T elem)
	| removed(&T elem)
	| unchanged()
	| modified(&T oldElem, &T newElem)
	;
	
data APISimpleChange 
	= new()
	| removed()
	| unchanged()
	| modified()
	;
	
data EntityType 
	= classType(APIChange[ClassType] ctChange)
	| returnType(APIChange[str] rtChange)
	;

data MethodInfo = methodInfo(int name, str cachedName); // This might go away!
	
data CompatibilityChange(bool binaryCompatible=false, bool sourceCompatible=false)
	= annotationDeprecatedAdded()
	| classRemoved()
	| classNowAbstract()
	| classNowFinal()
	| classNoLongerPublic()
	| classTypeChanged()
	| classNowCheckedException()
	| classLessAccessible()
	| superclassRemoved()
	| superclassAdded()
	| superclassModifiedIncompatible()
	| interfaceAdded()
	| interfaceRemoved()
	| methodRemoved()
	| methodRemovedInSuperclass()
	| methodLessAccessible()
	| methodLessAccessibleThanInSuperclass()
	| methodIsStaticAndOverridesNotStatic()
	| methodReturnTypeChanged()
	| methodNowAbstract()
	| methodNowFinal()
	| methodNowStatic()
	| methodNoLongerStatic()
	| methodAddedToInterface()
	| methodNowThrowsCheckedException()
	| methodAbstractAddedToClass()
	| methodAbstractAddedInSuperclass()
	| methodAbstractAddedInImplementedInterface()
	| methodNewDefault()
	| methodAbstractNowDefault()
	| fieldStaticAndOverridesStatic()
	| fieldLessAccessibleThanInSuperclass()
	| fieldNowFinal()
	| fieldNowStatic()
	| fieldNoLongerStatic()
	| fieldTypeChanged()
	| fieldRemoved()
	| fieldRemovedInSuperclass()
	| fieldLessAccessible()
	| constructorRemoved()
	| constructorLessAccessible()
	;
	
data ClassType
	= annotation()
	| interface()
	| class()
	| enum()
	;
	
data Modifier
	= packageProtected()
	| nonFinal()
	| nonStatic()
	| nonAbstract()
	| synthetic()
	| nonSynthetic()
	| bridge()
	| nonBridge()
	;

@javaClass{org.maracas.delta.internal.JApiCmp}
@reflect{for debugging}
java list[APIEntity] compareJars(loc oldJar, loc newJar, str oldVersion, str newVersion);

void myMain() {
	loc oldJar = |file:///Users/ochoa/Desktop/bacata/guava-18.0.jar|;
	str oldVersion = "18.0";
	loc newJar = |file:///Users/ochoa/Desktop/bacata/guava-19.0.jar|;
	str newVersion = "19.0";
	
	compareJars(oldJar, newJar, oldVersion, newVersion);
}