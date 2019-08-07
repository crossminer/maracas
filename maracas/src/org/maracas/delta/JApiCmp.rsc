module org::maracas::delta::JApiCmp

import lang::java::m3::AST;

data APIEntity
	= class(str fullyQualifiedName, 
	    EntityType classType, 
	    list[APIEntity] entities,
	    list[CompatibilityChange] compatibilityChanges,
	    APIChange[str] apiChange)
	| interface(str fullyQualifiedName, APIChangeStatus apiChange)
	| field(int name,
		str cachedName,
		list[APIEntity] entities, 
		list[CompatibilityChange] compatibilityChanges,
		APIChangeStatus apiChange)
	| method(str name, 
		EntityType returnType,
		list[APIEntity] entities,
		list[CompatibilityChange] compatibilityChanges,
		APIChange[MethodInfo] apiChange)
	| constructor(str name, 
		list[APIEntity] entities,
		list[CompatibilityChange] compatibilityChanges,
		APIChange[MethodInfo] apiChange)
	| annotation(str fullyQualifiedName, 
		list[APIEntity] entities,
		APIChange[int] apiChange)
	| annotationElement(str name, APIChange[str] valueAPIChange)
	| exception(str name, bool checkedException, APIChangeStatus apiChange)
	| parameter(str \type)
	| modifier(APIChange[Modifier] apiChange)
	| superclass(APIChange[str] apiChange) // Qualified names are considered
	;   

data APIChange[&T]
	= new(&T elem)
	| removed(&T elem)
	| unchanged()
	| modified(&T oldElem, &T newElem)
	;
	
data APIChangeStatus 
	= new()
	| removed()
	| unchanged()
	| modified()
	;
	
data EntityType 
	= classType(APIChange[ClassType] apiChange)
	| returnType(APIChange[str] apiChange)
	;

data MethodInfo = methodInfo(int name, str cachedName); // This might go away!

data CompatibilityChange = compatibilityChange(CompatibilityChangeType compatibilityChange, bool binaryCompatible, bool sourceCompatible);
	
data CompatibilityChangeType
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
