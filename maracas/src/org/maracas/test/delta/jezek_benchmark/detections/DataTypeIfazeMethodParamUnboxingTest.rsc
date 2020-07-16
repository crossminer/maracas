module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamUnboxing") == true;
	
test bool paramUnboxRem()
	= detection(
		|java+method:///dataTypeIfazeMethodParamUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamUnboxing/DataTypeIfazeMethodParamUnboxing/method1(java.lang.Integer)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamUnboxing/DataTypeIfazeMethodParamUnboxing/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool paramUnboxAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamUnboxing/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamUnboxing/DataTypeIfazeMethodParamUnboxing|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamUnboxing/DataTypeIfazeMethodParamUnboxing/method1(int)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;