module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnGen()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeGeneralization/DataTypeClazzMethodReturnTypeGeneralization/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeGeneralization/DataTypeClazzMethodReturnTypeGeneralization/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;