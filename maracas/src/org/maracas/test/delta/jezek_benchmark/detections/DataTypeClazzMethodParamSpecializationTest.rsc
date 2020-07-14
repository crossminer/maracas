module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzMethodParamSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool paramSpec()
	= detection(
		|java+method:///dataTypeClazzMethodParamSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamSpecialization/DataTypeClazzMethodParamSpecialization/method1(java.lang.Number)|,
		|java+method:///testing_lib/dataTypeClazzMethodParamSpecialization/DataTypeClazzMethodParamSpecialization/method1(java.lang.Number)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;