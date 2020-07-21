module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzFieldMutation");
	
test bool fieldMut()
	= detection(
		|java+method:///dataTypeClazzFieldMutation/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldMutation/DataTypeClazzFieldMutation/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldMutation/DataTypeClazzFieldMutation/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;