module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamBoxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamBoxing");
	
test bool paramBoxRem()
	= detection(
		|java+method:///dataTypeIfazeMethodParamBoxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamBoxing/DataTypeIfazeMethodParamBoxing/method1(int)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamBoxing/DataTypeIfazeMethodParamBoxing/method1(int)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool paramBoxAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamBoxing/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamBoxing/DataTypeIfazeMethodParamBoxing|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamBoxing/DataTypeIfazeMethodParamBoxing/method1(java.lang.Integer)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;