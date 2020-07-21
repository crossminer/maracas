module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamNarrowingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodParamNarrowing");
	
test bool paramNarrow()
	= detection(
		|java+method:///dataTypeClazzMethodParamNarrowing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamNarrowing/DataTypeClazzMethodParamNarrowing/method1(double)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamNarrowing/DataTypeClazzMethodParamNarrowing/method1(double)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;