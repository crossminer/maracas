module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodReturnTypeUnboxing");
	
test bool returnUnbox()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeUnboxing/DataTypeClazzMethodReturnTypeUnboxing/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeUnboxing/DataTypeClazzMethodReturnTypeUnboxing/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;