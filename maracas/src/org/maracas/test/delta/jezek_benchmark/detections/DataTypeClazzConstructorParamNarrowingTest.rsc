module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamNarrowingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool paramNarrow()
	= detection(
		|java+method:///dataTypeClazzConstructorParamNarrowing/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamNarrowing/DataTypeClazzConstructorParamNarrowing/DataTypeClazzConstructorParamNarrowing(double)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamNarrowing/DataTypeClazzConstructorParamNarrowing/DataTypeClazzConstructorParamNarrowing(double)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;