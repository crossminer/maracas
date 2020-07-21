module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzFieldUnboxing");
	
test bool fieldUnbox()
	= detection(
		|java+method:///dataTypeClazzFieldUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldUnboxing/DataTypeClazzFieldUnboxing/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldUnboxing/DataTypeClazzFieldUnboxing/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;