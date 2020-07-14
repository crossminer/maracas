module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnMut()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodVoidToInteger()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodVoidToInteger()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;