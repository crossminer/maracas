module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeBoxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodReturnTypeBoxing") == true;
	
test bool returnBox()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeBoxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeBoxing/DataTypeIfazeMethodReturnTypeBoxing/method1()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeBoxing/DataTypeIfazeMethodReturnTypeBoxing/method1()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;