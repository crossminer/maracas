module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamGeneralization") == true;
	
test bool paramGen()
	= detection(
		|java+method:///dataTypeIfazeMethodParamGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamGeneralization/DataTypeIfazeMethodParamGeneralization/method1(java.lang.Integer)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamGeneralization/DataTypeIfazeMethodParamGeneralization/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool paramGenAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamGeneralization/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamGeneralization/DataTypeIfazeMethodParamGeneralization|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamGeneralization/DataTypeIfazeMethodParamGeneralization/method1(java.lang.Number)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;