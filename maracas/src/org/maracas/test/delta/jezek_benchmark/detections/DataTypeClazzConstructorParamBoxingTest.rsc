module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamBoxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzConstructorParamBoxing");
	
test bool paramBox()
	= detection(
		|java+method:///dataTypeClazzConstructorParamBoxing/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamBoxing/DataTypeClazzConstructorParamBoxing/DataTypeClazzConstructorParamBoxing(int)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamBoxing/DataTypeClazzConstructorParamBoxing/DataTypeClazzConstructorParamBoxing(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;