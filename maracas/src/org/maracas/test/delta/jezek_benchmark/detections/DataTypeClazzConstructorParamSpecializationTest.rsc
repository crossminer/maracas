module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzConstructorParamSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzConstructorParamSpecialization");
	
test bool paramSpec()
	= detection(
		|java+method:///dataTypeClazzConstructorParamSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamSpecialization/DataTypeClazzConstructorParamSpecialization/DataTypeClazzConstructorParamSpecialization(java.lang.Number)|,
		|java+constructor:///testing_lib/dataTypeClazzConstructorParamSpecialization/DataTypeClazzConstructorParamSpecialization/DataTypeClazzConstructorParamSpecialization(java.lang.Number)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;