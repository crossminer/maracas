module org::maracas::\test::delta::japicmp::detections::AnnotationDeprecatedAddedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool emptyClassTD() 
	= detection(
		|java+field:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/emptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool emptyClassConstructorMI() 
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassEmpty()|,
		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass/AnnDeprAddedEmptyClass()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassConstructorMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmpty()|,
		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/AnnDeprAddedNonEmptyClass()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;
    
test bool nonEmptyClassTransField()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmpty()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool nonEmptyClassTransMethod()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassNonEmpty()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
  
test bool nonEmptyClassFieldDep() 
	= detection(
		|java+field:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/nonEmptyClass|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool fieldFA() 
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedField()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedFieldMethod/field|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool methodMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedMethod()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedFieldMethod/method()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedInterfaceAsTypeParam()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAsTypeParam()|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedEmptyClassMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedEmptyClassMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedEmptyClassTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedEmptyClassTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAnonymous()|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedInterfaceMI()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAnonymous()|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool anonymousDeprecatedInterfaceTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAnonymous()|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedClassAsParameterTD()
	= detection(
		|java+parameter:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedClassAsParameter(main.annotationDeprecatedAdded.AnnDeprAddedEmptyClass)/param0|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedEmptyClass|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedInterfaceAsReturnTypeTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAsReturnType()|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool deprecatedInterfaceAsTypeParamTD()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedSA/deprecatedInterfaceAsTypeParam()|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		typeDependency(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;

test bool extendClass()
	= detection(
		|java+class:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt|,
		|java+class:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass|,
		extends(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;

test bool extendClassCons() 
	= detection(
		|java+constructor:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/AnnotationDeprecatedAddedExt()|,
		|java+constructor:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/AnnDeprAddedNonEmptyClass()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;

test bool extendClassTransFieldSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedSuperKey()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool extendClassTransMehtodSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedSuperKey()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool extendClassTransFieldNoSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedNoSuperKey()|,
		|java+field:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transField|,
		fieldAccess(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
    
test bool extendClassTransMehtodNoSuperKey()
	= detection(
		|java+method:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedExt/deprecatedNoSuperKey()|,
		|java+method:///main/annotationDeprecatedAdded/AnnDeprAddedNonEmptyClass/transMethod()|,
		methodInvocation(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	in detects;
	
test bool implementInt() 
	= detection(
		|java+class:///mainclient/annotationDeprecatedAdded/AnnotationDeprecatedAddedImp|,
		|java+interface:///main/annotationDeprecatedAdded/IAnnDeprAdded|,
		implements(),
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
    in detects;
