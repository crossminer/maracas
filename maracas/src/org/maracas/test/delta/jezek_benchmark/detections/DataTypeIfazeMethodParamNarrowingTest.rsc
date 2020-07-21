module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodParamNarrowingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodParamNarrowing");
	
test bool paramNarrowRem()
	= detection(
		|java+method:///dataTypeIfazeMethodParamNarrowing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamNarrowing/DataTypeIfazeMethodParamNarrowing/method1(double)|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamNarrowing/DataTypeIfazeMethodParamNarrowing/method1(double)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool paramNarrowAdd()
	= detection(
		|java+class:///dataTypeIfazeMethodParamNarrowing/Main|,
		|java+interface:///testing_lib/dataTypeIfazeMethodParamNarrowing/DataTypeIfazeMethodParamNarrowing|,
		|java+method:///testing_lib/dataTypeIfazeMethodParamNarrowing/DataTypeIfazeMethodParamNarrowing/method1(int)|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;