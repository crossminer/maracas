module org::maracas::\test::delta::japicmp::detections::ClassNowCheckedExceptionTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool methThrowsExcep()
	= detection(
		|java+method:///mainclient/classNowCheckedException/ClassNowCheckedExceptionThrows/throwsExcep(boolean)|,
		|java+class:///main/classNowCheckedException/ClassNowCheckedException|,
		typeDependency(),
		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
