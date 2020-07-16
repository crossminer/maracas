module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeConstantMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeConstantMutation") == true;
	
test bool constTypeCh()
	= detection(
		|java+method:///dataTypeIfazeConstantMutation/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeIfazeConstantMutation/DataTypeIfazeConstantMutation/FIELD1|,
		|java+field:///testing_lib/dataTypeIfazeConstantMutation/DataTypeIfazeConstantMutation/FIELD1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;