module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool paramUnbox()
	= detection(
		|java+method:///dataTypeClazzConstructorParamUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamUnboxing/DataTypeClazzConstructorParamUnboxing/DataTypeClazzConstructorParamUnboxing(java.lang.Integer)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamUnboxing/DataTypeClazzConstructorParamUnboxing/DataTypeClazzConstructorParamUnboxing(java.lang.Integer)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;