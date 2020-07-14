module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodReturnTypeSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool returnSpec()
	= detection(
		|java+method:///dataTypeClazzMethodReturnTypeSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeSpecialization/DataTypeClazzMethodReturnTypeSpecialization/method()|,
		|java+method:///testing_lib/dataTypeClazzMethodReturnTypeSpecialization/DataTypeClazzMethodReturnTypeSpecialization/method()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;