module org::maracas::delta::JApiCmp

import IO;
import lang::java::m3::AST;

data APIEntity
	= class(str className, //fullyQualifiedName TODO: loc
	    EntityType classType, 
	    list[APIEntity] classEntities,
	    list[CompatibilityChange] classChanges,
	    APISimpleChange classChange)
	| interface(str interName, //fullyQualifiedName TODO: loc
		list[CompatibilityChange] interChanges,
		APISimpleChange interChange) 
	| field(str fieldName, // simpleName TODO: is it align with m3 names?
		EntityType fieldType,
		list[APIEntity] fieldEntities, 
		list[CompatibilityChange] fieldChanges,
		APISimpleChange fieldChange)
	| method(str methName, // simplaName TODO: loc (more complex but doable)
		EntityType returnType,
		list[APIEntity] methEntities,
		list[CompatibilityChange] methChanges,
		APISimpleChange methChange)
	| constructor(str consName,
		list[APIEntity] consEntities,
		list[CompatibilityChange] consChanges,
		APISimpleChange consChange)
	| annotation(str annName, //fullyQualifiedName TODO: loc
		list[APIEntity] annEntities,
		list[CompatibilityChange] annChanges,
		APISimpleChange annChange)
	| annotationElement(str annElemName, APIChange[list[str]] annElemChange) // simplaName
	| exception(str excepName, //fullyQualifiedName TODO: loc
		bool checkedException, 
		APISimpleChange excepChange)
	| parameter(str \type) //fullyQualifiedName TODO: loc
	| modifier(APIChange[Modifier] modifChange)
	| superclass(APIChange[str] superChange) // fullyQualifiedName TODO: loc
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
	| fieldType(APIChange[str] ftChange)
	| returnType(APIChange[str] rtChange)
	;
	
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

list[APIEntity] myMain() {
	loc oldJar = |file:///Users/ochoa/Desktop/bacata/guava-18.0.jar|;
	str oldVersion = "18.0";
	loc newJar = |file:///Users/ochoa/Desktop/bacata/guava-19.0.jar|;
	str newVersion = "19.0";
	
	return entities = compareJars(oldJar, newJar, oldVersion, newVersion);
}