module org::maracas::\test::delta::japicmp::detections::ClassNowCheckedExceptionTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool throwsExcep()
	= detection(
		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsExcep(boolean)|,
		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
		methodInvocation(),
		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool throwsSubExcep()
	= detection(
		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsSubExcep(boolean)|,
		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
		methodInvocation(),
		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool throwsClientExcep()
	= detection(
		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsClientExcep(boolean)|,
		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
		methodInvocation(),
		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool throwsClientSubExcep()
	= detection(
		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsClientSubExcep(boolean)|,
		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
		methodInvocation(),
		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

//test bool throwsExcepChecked()
//	= detection(
//		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsExcepChecked(boolean)|,
//		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
//		methodInvocation(),
//		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
//	notin detects;	
//	
//test bool throwsSubExcepChecked()
//	= detection(
//		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsSubExcepChecked(boolean)|,
//		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
//		methodInvocation(),
//		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
//	notin detects;
//
//test bool throwsClientExcepChecked()
//	= detection(
//		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsClientExcepChecked(boolean)|,
//		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
//		methodInvocation(),
//		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
//	notin detects;
//	
//test bool throwsClientSubExcepChecked()
//	= detection(
//		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsClientSubExcepChecked(boolean)|,
//		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
//		methodInvocation(),
//		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
//	notin detects;
//
//test bool subExcepConstructor() 
//	= detection(
//		|java+constructor:///mainclient/classNowCheckedException/ClassNowCheckedExceptionClientSub/ClassNowCheckedExceptionClientSub()|,
//		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
//		methodInvocation(),
//		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
//	notin detects;