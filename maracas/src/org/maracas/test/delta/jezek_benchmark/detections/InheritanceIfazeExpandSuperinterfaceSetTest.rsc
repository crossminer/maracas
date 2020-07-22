module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceIfazeExpandSuperinterfaceSetTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("inheritanceIfazeExpandSuperinterfaceSet");
	
test bool interAdd()
	= detection(
		|java+class:///inheritanceIfazeExpandSuperinterfaceSet/Main|,
		|java+interface:///testing_lib/inheritanceIfazeExpandSuperinterfaceSet/InheritanceIfazeExpandSuperinterfaceSet|,
		|java+interface:///testing_lib/inheritanceIfazeExpandSuperinterfaceSet/InheritanceIfazeExpandSuperinterfaceSet|,
		implements(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;