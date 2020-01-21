module org::maracas::\test::delta::japicmp::detections::ClassNowAbstractTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool createObject() 
	= detection(
		|java+method:///mainclient/classNowAbstract/ClassNowAbstractMI/createObject()|,
		|java+class:///main/classNowAbstract/ClassNowAbstract|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool createObjectParams() 
	= detection(
		|java+method:///mainclient/classNowAbstract/ClassNowAbstractMI/createObjectParams()|,
		|java+class:///main/classNowAbstract/ClassNowAbstract|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

//test bool consOverride()
//	= detection(
//		|java+method:///mainclient/classNowAbstract/ClassNowAbstractExt/ClassNowAbstractExt()|,
//		|java+constructor:///main/classNowAbstract/ClassNowAbstract/ClassNowAbstract()|,
//		methodInvocation(),
//		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
//	notin detects;
//	
//test bool consOverrideParams()
//	= detection(
//		|java+method:///mainclient/classNowAbstract/ClassNowAbstractExt/ClassNowAbstractExt(int)|,
//		|java+constructor:///main/classNowAbstract/ClassNowAbstract/ClassNowAbstract(int)|,
//		methodInvocation(),
//		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
//	notin detects;

//FIXME: the interface scheme is wrong
test bool interCreateObject() 
	= detection(
		|java+method:///mainclient/classNowAbstract/IClassNowAbstractMI/createObject()|,
		|java+class:///main/classNowAbstract/IClassNowAbstract|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool interCreateObjectParams() 
	= detection(
		|java+method:///mainclient/classNowAbstract/IClassNowAbstractMI/createObjectParams()|,
		|java+class:///main/classNowAbstract/IClassNowAbstract|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// test bool interConsOverride()
// 	= detection(
// 		|java+constructor:///mainclient/classNowAbstract/IClassNowAbstractExt/IClassNowAbstractExt()|,
// 		|java+constructor:///main/classNowAbstract/IClassNowAbstract/IClassNowAbstract()|,
// 		methodInvocation(),
// 		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
// 	notin detects;
//   
//test bool interConsOverrideParams()
//	= detection(
//		|java+constructor:///mainclient/classNowAbstract/IClassNowAbstractExt/IClassNowAbstractExt(int)|,
//		|java+constructor:///main/classNowAbstract/IClassNowAbstract/IClassNowAbstract(int)|,
//		methodInvocation(),
//		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
//	notin detects;
    