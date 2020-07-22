module org::maracas::\test::delta::jezek_benchmark::detections::MembersIfazeNestedIfazeDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// TODO: no reference to method main()
test bool occurrence()
	= containsCase("membersIfazeNestedIfazeDelete");
	
test bool implRem()
	= detection(
		|java+class:///membersIfazeNestedIfazeDelete/Main|,
		|java+interface:///testing_lib/membersIfazeNestedIfazeDelete/MembersIfazeNestedIfazeDelete$NestedIfaze|,
		|java+interface:///testing_lib/membersIfazeNestedIfazeDelete/MembersIfazeNestedIfazeDelete$NestedIfaze|,
		implements(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool depRem()
	= detection(
		|java+class:///membersIfazeNestedIfazeDelete/Main|,
		|java+interface:///testing_lib/membersIfazeNestedIfazeDelete/MembersIfazeNestedIfazeDelete$NestedIfaze|,
		|java+interface:///testing_lib/membersIfazeNestedIfazeDelete/MembersIfazeNestedIfazeDelete$NestedIfaze|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;