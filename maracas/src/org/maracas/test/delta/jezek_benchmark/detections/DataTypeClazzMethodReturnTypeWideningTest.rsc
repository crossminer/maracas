module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeWideningTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodReturnTypeWidening");
	
test bool returnWide()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeWidening/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeWidening/DataTypeClazzMethodReturnTypeWidening/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeWidening/DataTypeClazzMethodReturnTypeWidening/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;