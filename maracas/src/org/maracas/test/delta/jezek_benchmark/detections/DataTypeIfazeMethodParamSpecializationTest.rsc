module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamSpecialization");
	
test bool paramSpecRem()
	= detection(	
		|java+method:///dataTypeIfazeMethodParamSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamSpecialization/DataTypeIfazeMethodParamSpecialization/method1(java.lang.Number)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamSpecialization/DataTypeIfazeMethodParamSpecialization/method1(java.lang.Number)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool paramSpecAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamSpecialization/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamSpecialization/DataTypeIfazeMethodParamSpecialization|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamSpecialization/DataTypeIfazeMethodParamSpecialization/method1(java.lang.Integer)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;