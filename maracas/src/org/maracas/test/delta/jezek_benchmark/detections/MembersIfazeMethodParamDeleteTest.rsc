module org::maracas::\test::delta::jezek_benchmark::detections::MembersIfazeMethodParamDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// TODO: methodOverride
test bool occurrence()
	= containsCase("membersIfazeMethodParamDelete") == true;
	
// It is reported as a methodAddedToInterface change
test bool methAdd()
	= detection(
		|java+class:///membersIfazeMethodParamDelete/Main|,
		|java+interface:///testing_lib/membersIfazeMethodParamDelete/MembersIfazeMethodParamDelete|,
		|java+method:///testing_lib/membersIfazeMethodParamDelete/MembersIfazeMethodParamDelete/method1()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;