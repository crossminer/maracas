module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodReturnTypeGeneralization");
	
test bool returnGen()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeGeneralization/DataTypeIfazeMethodReturnTypeGeneralization/method1()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeGeneralization/DataTypeIfazeMethodReturnTypeGeneralization/method1()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;