module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldBoxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzFieldBoxing");
	
test bool fieldBox()
	= detection(
		|java+method:///dataTypeClazzFieldBoxing/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldBoxing/DataTypeClazzFieldBoxing/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldBoxing/DataTypeClazzFieldBoxing/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;