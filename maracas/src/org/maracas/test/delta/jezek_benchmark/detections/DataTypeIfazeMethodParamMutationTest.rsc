module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamMutation");
	
test bool paramMutRem()
	= detection(
		|java+method:///dataTypeIfazeMethodParamMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamMutation/DataTypeIfazeMethodParamMutation/method1(java.lang.Integer)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamMutation/DataTypeIfazeMethodParamMutation/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool paramMutAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamMutation/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamMutation/DataTypeIfazeMethodParamMutation|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamMutation/DataTypeIfazeMethodParamMutation/method1(java.lang.String)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;