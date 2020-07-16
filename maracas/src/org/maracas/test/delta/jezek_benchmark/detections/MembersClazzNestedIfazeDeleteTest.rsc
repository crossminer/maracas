module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzNestedIfazeDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersClazzNestedIfazeDelete") == true;
	
// TODO: no reference to method main()
test bool implRem()
	= detection(
		|java+class:///membersClazzNestedIfazeDelete/Main|,
		|java+interface:///testing_lib/membersClazzNestedIfazeDelete/MembersClazzNestedIfazeDelete$NestedIfaze|,
		|java+interface:///testing_lib/membersClazzNestedIfazeDelete/MembersClazzNestedIfazeDelete$NestedIfaze|,
		implements(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool depRem()    
	= detection(
		|java+class:///membersClazzNestedIfazeDelete/Main|,
		|java+interface:///testing_lib/membersClazzNestedIfazeDelete/MembersClazzNestedIfazeDelete$NestedIfaze|,
		|java+interface:///testing_lib/membersClazzNestedIfazeDelete/MembersClazzNestedIfazeDelete$NestedIfaze|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;