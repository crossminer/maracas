module org::maracas::\test::delta::jezek_benchmark::detections::MembersIfazeMethodAddTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersIfazeMethodAdd") == true;
	
test bool addMethInt()
	= detection(
		|java+class:///membersIfazeMethodAdd/Main|,
		|java+interface:///testing_lib/membersIfazeMethodAdd/MembersIfazeMethodAdd|,
		|java+method:///testing_lib/membersIfazeMethodAdd/MembersIfazeMethodAdd/method1()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;