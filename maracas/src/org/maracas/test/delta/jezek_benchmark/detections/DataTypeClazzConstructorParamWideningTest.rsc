module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamWideningTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool paramWide()
	= detection(
		|java+method:///dataTypeClazzConstructorParamWidening/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamWidening/DataTypeClazzConstructorParamWidening/DataTypeClazzConstructorParamWidening(int)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamWidening/DataTypeClazzConstructorParamWidening/DataTypeClazzConstructorParamWidening(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;