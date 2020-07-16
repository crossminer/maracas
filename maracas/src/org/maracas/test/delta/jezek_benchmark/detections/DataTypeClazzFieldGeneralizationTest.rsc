module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzFieldGeneralization") == true;
	
test bool fieldGen()
	= detection(
		|java+method:///dataTypeClazzFieldGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldGeneralization/DataTypeClazzFieldGeneralization/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldGeneralization/DataTypeClazzFieldGeneralization/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;