module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceIfazeStartInheriteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool interAdd()
	= detection(
		|java+class:///inheritanceIfazeStartInherite/Main|,
		|java+interface:///testing_lib/inheritanceIfazeStartInherite/InheritanceIfazeStartInherite|,
		|java+interface:///testing_lib/inheritanceIfazeStartInherite/InheritanceIfazeStartInherite|,
		implements(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;