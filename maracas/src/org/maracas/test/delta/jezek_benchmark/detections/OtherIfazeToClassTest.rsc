module org::maracas::\test::delta::jezek_benchmark::detections::OtherIfazeToClassTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool changeType()
	= detection(
		|java+class:///otherIfazeToClass/Main|,
		|java+interface:///testing_lib/otherIfazeToClass/IfazeToClass|,
		|java+interface:///testing_lib/otherIfazeToClass/IfazeToClass|,
		implements(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;