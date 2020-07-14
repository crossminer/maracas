module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeMethodReturnTypeSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnSepc()
	= detection(
		|java+method:///dataTypeIfazeMethodReturnTypeSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeSpecialization/DataTypeIfazeMethodReturnTypeSpecialization/method1()|,
		|java+method:///testing_lib/dataTypeIfazeMethodReturnTypeSpecialization/DataTypeIfazeMethodReturnTypeSpecialization/method1()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;