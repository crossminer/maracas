module org::maracas::\test::delta::jezek_benchmark::detections::OtherIfazeDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool depRem()
	= detection(
		|java+class:///otherIfazeDelete/Main|,
		|java+interface:///testing_lib/otherIfazeDelete/OtherIfazeDelete|,
		|java+interface:///testing_lib/otherIfazeDelete/OtherIfazeDelete|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impRem()
	= detection(
		|java+class:///otherIfazeDelete/Main|,
		|java+interface:///testing_lib/otherIfazeDelete/OtherIfazeDelete|,
		|java+interface:///testing_lib/otherIfazeDelete/OtherIfazeDelete|,
		implements(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;