module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzConstructorParamGeneralization") == true;
	
test bool paramGen()
	= detection(
		|java+method:///dataTypeClazzConstructorParamGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamGeneralization/DataTypeClazzConstructorParamGeneralization/DataTypeClazzConstructorParamGeneralization(java.lang.Integer)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamGeneralization/DataTypeClazzConstructorParamGeneralization/DataTypeClazzConstructorParamGeneralization(java.lang.Integer)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;