module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeBoxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodReturnTypeBoxing") == true;
	
test bool returnBox()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeBoxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeBoxing/DataTypeClazzMethodReturnTypeBoxing/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeBoxing/DataTypeClazzMethodReturnTypeBoxing/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;