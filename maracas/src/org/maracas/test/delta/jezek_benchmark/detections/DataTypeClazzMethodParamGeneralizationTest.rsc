module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodParamGeneralization");
	
test bool paramGen()
	= detection(
		|java+method:///dataTypeClazzMethodParamGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamGeneralization/DataTypeClazzMethodParamGeneralization/method1(java.lang.Integer)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamGeneralization/DataTypeClazzMethodParamGeneralization/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;