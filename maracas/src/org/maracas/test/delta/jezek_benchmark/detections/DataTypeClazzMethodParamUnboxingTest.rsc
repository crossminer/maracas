module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodParamUnboxing");
	
test bool paramUnbox()
	= detection(
		|java+method:///dataTypeClazzMethodParamUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamUnboxing/DataTypeClazzMethodParamUnboxing/method1(java.lang.Integer)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamUnboxing/DataTypeClazzMethodParamUnboxing/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;