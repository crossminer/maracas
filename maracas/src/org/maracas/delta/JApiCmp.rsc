module org::maracas::delta::JApiCmp


data JApiEntity
	= class(str fullyQualifiedName, 
	    JApiType classType, 
	    list[JApiEntity] entities,
	    list[JApiCompatibilityChange] compatibilityChanges,
	    APIChange[str] apiChange)
	| interface(str fullyQualifiedName, APIChange[value] apiChange)
	| field(int name,
		str cachedName,
		list[JApiEntity] entities, 
		list[JApiCompatibilityChange] compatibilityChanges,
		APIChange[value] apiChange)
	| method(str name, 
		JApiType returnType,
		list[JApiEntity] entities,
		list[JApiCompatibilityChange] compatibilityChanges,
		APIChange[MethodInfo] apiChange)
	| constructor(str name, 
		list[JApiEntity] entities,
		list[JApiCompatibilityChange] compatibilityChanges,
		APIChange[MethodInfo] apiChange)
	| annotation(str fullyQualifiedName, 
		list[JApiEntity] entities,
		APIChange[int] apiChange)
	| annotationElement(str name, APIChange[str] valueAPIChange)
	| exception(str name, bool checkedException, APIChange[value] apiChange)
	| parameter(str \type)
	| modifier(ModifierType modifierType, APIChange[Modifier] apiChange)
	| superclass(APIChange[str] apiChange) // Qualified names are considered
	;   

data APIChange[&T]
	= new(&T oldElem, &T newElem)
	| removed(&T oldElem, &T newElem)
	| unchanged(&T oldElem, &T newElem)
	| modified(&T oldElem, &T newElem)
	| new()
	| removed()
	| unchanged()
	| modified()
	;
	
data JApiType 
	= classType(APIChange[ClassType] classTypeAPIChange)
	| returnType(APIChange[str] apiChange)
	;

data MethodInfo = methodInfo(int name, str cachedName);

data JApiCompatibilityChange = compatibilityChange(CompatibilityChange compatibilityChange, bool binaryCompatible, bool sourceCompatible);
	
data CompatibilityChange
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

data ModifierType
	= access()
	| final()
	| static()
	| abstract()
	| synthetic()
	| bridge()
	;
	
data Modifier
	= \public()
	| protected()
	| packageProtected()
	| \private()
	| final()
	| nonFinal()
	| static()
	| nonStatic()
	| abstract()
	| nonAbstract()
	| synthetic()
	| nonSynthetic()
	| bridge()
	| nonBridge()
	;