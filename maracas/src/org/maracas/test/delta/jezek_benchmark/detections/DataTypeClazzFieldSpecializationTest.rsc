module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool fieldSpec()
	= detection(
		|java+method:///dataTypeClazzFieldSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldSpecialization/DataTypeClazzFieldSpecialization/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldSpecialization/DataTypeClazzFieldSpecialization/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;