module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceIfazeStopInheriteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool interRem()
	= detection(
		|java+method:///inheritanceIfazeStopInherite/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/inheritanceIfazeStopInherite/InheritanceIfazeStopInherite/method1()|,
		|java+interface:///testing_lib/inheritanceIfazeStopInherite/Interface1|,
		methodInvocation(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;