module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldWideningTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzFieldWidening");
	
test bool fieldWide()
	= detection(
		|java+method:///dataTypeClazzFieldWidening/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldWidening/DataTypeClazzFieldWidening/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldWidening/DataTypeClazzFieldWidening/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;