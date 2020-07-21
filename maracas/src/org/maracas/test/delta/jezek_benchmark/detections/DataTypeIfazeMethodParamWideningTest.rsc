module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamWideningTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamWidening");
	
test bool paramWideRem()
	= detection(
		|java+method:///dataTypeIfazeMethodParamWidening/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamWidening/DataTypeIfazeMethodParamWidening/method1(int)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamWidening/DataTypeIfazeMethodParamWidening/method1(int)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool paraWideAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamWidening/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamWidening/DataTypeIfazeMethodParamWidening|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamWidening/DataTypeIfazeMethodParamWidening/method1(double)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;