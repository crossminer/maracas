module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzMethodReturnTypeMutation");
	
test bool returnMut()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeMutation/DataTypeClazzMethodReturnTypeMutation/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeMutation/DataTypeClazzMethodReturnTypeMutation/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;