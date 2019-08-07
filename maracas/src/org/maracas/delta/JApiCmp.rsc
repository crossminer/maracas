module org::maracas::delta::JApiCmp

data JApiClass
	= class(
		str fullyQualifiedName, 
	    JApiClassType classType, 
	    JApiSuperclass superclass,
	    list[JApiModifier] modifiers, 
	    list[JApiInterface] interfaces,
	    list[JApiField] fields,
	    list[JApiMethod] methods,
	    list[JApiAnnotation] annotations,
	    list[JApiCompatibilityChange] compatibilityChanges,
	    APIChange[str] classAPIChange)
	;

data JApiClassType = classType(APIChange[ClassType] classTypeAPIChange);

// Qualified names are considered
data JApiSuperclass	= superclass(APIChange[str] superclassAPIChange);

data JApiInterface = interface(str fullyQualifiedName, APIChange[value] apiChange);

data JApiField
	= field(
		int name,
		str cachedName,
		list[JApiModifier] modifiers, 
		list[JApiAnnotation] annotations, 
		list[JApiCompatibilityChange] compatibilityChanges,
		APIChange[value] apiChange)
	;
	
data JApiMethod 
	= method(JApiMethodBehavior behavior, JApiReturnType returnType)
	| constructor(JApiMethodBehavior behavior)
	;

data JApiReturnType	= returnType(APIChange[str] returnTypeAPIChange);
	
data MethodInfo = methodInfo(int name, str cachedName);
	
data JApiAnnotation
	= annotation(
		str fullyQualifiedName, 
		int oldAnnotation, 
		int newAnnotation, 
		list[JApiAnnotationElement] elements,
		APIChange[value] apiChange)
	;

data JApiAnnotationElement = annotationElement(str name, APIChange[str] valueAPIChange);
	
data JApiMethodBehavior 
	= behavior(
		str name, 
		list[JApiModifier] modifiers, 
		list[JApiParameter] parameters, 
		list[JApiAnnotation] annotations,
		list[JApiException] exceptions,
		list[JApiCompatibilityChange] compatibilityChanges,
		APIChange[MethodInfo] methodAPIChange)
	;

data JApiException = exception(str name, bool checkedException, APIChange apiChange);

data JApiParameter = parameter(str \type);

data JApiModifier = modifier(ModifierType modifierType, APIChange[Modifier] modifierAPIChange);

data JApiType = \type(APIChange[str] typeAPIChange);

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