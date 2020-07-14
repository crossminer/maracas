module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnUnbox()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeUnboxing/DataTypeIfazeMethodReturnTypeUnboxing/method1()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeUnboxing/DataTypeIfazeMethodReturnTypeUnboxing/method1()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;