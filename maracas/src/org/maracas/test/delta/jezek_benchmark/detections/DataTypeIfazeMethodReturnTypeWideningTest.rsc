module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeWideningTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnWide()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeWidening/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeWidening/DataTypeIfazeMethodReturnTypeWidening/method1()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeWidening/DataTypeIfazeMethodReturnTypeWidening/method1()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;