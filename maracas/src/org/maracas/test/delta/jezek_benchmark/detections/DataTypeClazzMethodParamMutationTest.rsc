module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool paramMut()
	= detection(
		|java+method:///dataTypeClazzMethodParamMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamMutation/DataTypeClazzMethodParamMutation/method1(java.lang.Integer)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamMutation/DataTypeClazzMethodParamMutation/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;