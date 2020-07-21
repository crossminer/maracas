module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeMethodReturnTypeMutation");
	
test bool returnMutToInt()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodVoidToInteger()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodVoidToInteger()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool returnMutToString()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodIntegerToString()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodIntegerToString()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool returnMutToVoid()  
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodIntegerToVoid()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeMutation/DataTypeIfazeMethodReturnTypeMutation/methodIntegerToVoid()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;