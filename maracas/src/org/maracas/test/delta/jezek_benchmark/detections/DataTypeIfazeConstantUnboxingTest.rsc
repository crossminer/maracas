module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeConstantUnboxingTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool consUnbox()
	= detection(
		|java+method:///dataTypeIfazeConstantUnboxing/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeIfazeConstantUnboxing/DataTypeIfazeConstantUnboxing/FIELD1|,
		|java+field:///testing_lib/dataTypeIfazeConstantUnboxing/DataTypeIfazeConstantUnboxing/FIELD1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;