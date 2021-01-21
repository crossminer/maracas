module org::maracas::\test::delta::japicmp::source::detections::AnnotationDeprecatedAddedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;

test bool emptyClassTD() 
	= detection(
		|java+field:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/emptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool emptyClassConstructorMI() 
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassEmpty()|,
		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass/AnnDeprAddedEmptyClass()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassConstructorMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmpty()|,
		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/AnnDeprAddedNonEmptyClass()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;
    
test bool nonEmptyClassTransField()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmpty()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassTransMethod()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmpty()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
  
test bool nonEmptyClassFieldDep() 
	= detection(
		|java+field:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/nonEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassSubTrans()
	= detection(
	    |java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmptySub()|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    typeDependency(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassSubTransField()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmptySub()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassSubTransMethod()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmptySub()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
  
test bool nonEmptyClassSubFieldDep() 
	= detection(
		|java+field:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/nonEmptyClassSub|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	notin detects;
    
test bool fieldFA() 
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedField()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedFieldMethod/field|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedFieldMethod/field|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool methodMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedMethod()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedFieldMethod/method()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedFieldMethod/method()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedInterfaceAsTypeParam()
	= detection(
		|java+variable:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAsTypeParam()/a|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedEmptyClassExt()
	= detection(
	    |java+anonymousClass:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()/$anonymous1|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
	    extends(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedEmptyClassTD()
	= detection(
	    |java+anonymousClass:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()/$anonymous1|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
	    typeDependency(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedNonEmptyClassExt()
	= detection(
	    |java+anonymousClass:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()/$anonymous2|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    extends(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedNonEmptyClassTD()
	= detection(
	    |java+anonymousClass:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()/$anonymous2|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    typeDependency(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedInterfaceIMPL()
	= detection(
	    |java+anonymousClass:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAnonymous()/$anonymous1|,
	    |java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
	    |java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
	    implements(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedInterfaceTD()
	= detection(
	    |java+anonymousClass:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAnonymous()/$anonymous1|,
	    |java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
	    |java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
	    typeDependency(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedClassAsParameterTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAsParameter(main.annotationDeprecatedAdded.AnnDeprAddedEmptyClass)/scope(a)/scope(0)|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedInterfaceAsReturnTypeTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAsReturnType()|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

// Cannot be detected due to type erasure
//test bool deprecatedInterfaceAsTypeParamTD()
//	= detection(
//		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAsTypeParam()|,
//		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
//		typeDependency(),
//		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
//	in detects;

test bool extendClass()
	= detection(
		|java+class:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		extends(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;

// No constructor in source code
//test bool extendClassCons() 
//	= detection(
//		|java+constructor:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/AnnotationDeprecatedAddedExt()|,
//		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/AnnDeprAddedNonEmptyClass()|,
//		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
//		methodInvocation(),
//		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
//    in detects;

test bool extendClassTransFieldSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedSuperKey()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool extendClassTransMehtodSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedSuperKey()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool extendClassTransFieldNoSuperKey()
	= detection(
	    |java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedNoSuperKey()|,
	    |java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    fieldAccess(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool extendClassTransMehtodNoSuperKey()
	= detection(
	    |java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedNoSuperKey()|,
	    |java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
	    |java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
	    methodInvocation(),
	    annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool extendClassSubCons() 
	= detection(
		|java+constructor:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExtSub/AnnotationDeprecatedAddedExtSub()|,
		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/AnnDeprAddedNonEmptyClass()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    notin detects;

test bool extendClassSubTransFieldSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExtSub/deprecatedSuperKey()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool extendClassSubTransMehtodSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExtSub/deprecatedSuperKey()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool extendClassSubTransClassNoSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExtSub/deprecatedNoSuperKey()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool extendClassSubTransFieldNoSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExtSub/deprecatedNoSuperKey()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool extendClassSubTransMehtodNoSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExtSub/deprecatedNoSuperKey()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool implementInt() 
	= detection(
		|java+class:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedImp|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		implements(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;
