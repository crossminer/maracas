module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeNarrowingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnNarrow()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeNarrowing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeNarrowing/DataTypeClazzMethodReturnTypeNarrowing/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeNarrowing/DataTypeClazzMethodReturnTypeNarrowing/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;