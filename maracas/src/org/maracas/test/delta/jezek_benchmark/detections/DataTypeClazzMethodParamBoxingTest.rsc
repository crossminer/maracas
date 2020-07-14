module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamBoxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool paramBox()
	= detection(
		|java+method:///dataTypeClazzMethodParamBoxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamBoxing/DataTypeClazzMethodParamBoxing/method1(int)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamBoxing/DataTypeClazzMethodParamBoxing/method1(int)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;