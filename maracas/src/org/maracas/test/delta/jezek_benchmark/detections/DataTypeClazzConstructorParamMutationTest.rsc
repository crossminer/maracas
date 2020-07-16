module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzConstructorParamMutation") == true;
	
test bool paramMut()
	= detection(
		|java+method:///dataTypeClazzConstructorParamMutation/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamMutation/DataTypeClazzConstructorParamMutation/DataTypeClazzConstructorParamMutation(java.lang.Integer)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamMutation/DataTypeClazzConstructorParamMutation/DataTypeClazzConstructorParamMutation(java.lang.Integer)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;