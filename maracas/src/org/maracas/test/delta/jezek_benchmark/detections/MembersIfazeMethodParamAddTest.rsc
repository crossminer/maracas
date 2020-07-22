module org::maracas::\test::delta::jezek_benchmark::detections::MembersIfazeMethodParamAddTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

// TODO: methodOverride
test bool occurrence()
	= containsCase("membersIfazeMethodParamAdd");

test bool methAdd()
	= detection(
		|java+class:///membersIfazeMethodParamAdd/Main|,
		|java+interface:///testing_lib/membersIfazeMethodParamAdd/MembersIfazeMethodParamAdd|,
		|java+method:///testing_lib/membersIfazeMethodParamAdd/MembersIfazeMethodParamAdd/method1(java.lang.Integer)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;