module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeClazzFieldNarrowingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeClazzFieldNarrowing") == true;
	
test bool fieldNarrow()
	= detection(
		|java+method:///dataTypeClazzFieldNarrowing/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeClazzFieldNarrowing/DataTypeClazzFieldNarrowing/field1|,
		|java+field:///testing_lib/dataTypeClazzFieldNarrowing/DataTypeClazzFieldNarrowing/field1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;