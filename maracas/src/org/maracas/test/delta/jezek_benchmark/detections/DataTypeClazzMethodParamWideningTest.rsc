module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamWideningTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodParamWidening");
	
test bool paramWide()
	= detection(
		|java+method:///dataTypeClazzMethodParamWidening/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamWidening/DataTypeClazzMethodParamWidening/method1(int)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamWidening/DataTypeClazzMethodParamWidening/method1(int)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;