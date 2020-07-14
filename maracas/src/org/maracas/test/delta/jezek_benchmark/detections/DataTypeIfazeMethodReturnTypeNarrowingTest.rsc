module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeNarrowingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnNarrow()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeNarrowing/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeNarrowing/DataTypeIfazeMethodReturnTypeNarrowing/method1()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeNarrowing/DataTypeIfazeMethodReturnTypeNarrowing/method1()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;