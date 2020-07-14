module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeConstantGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool constTypeCh()
	= detection(
		|java+method:///dataTypeIfazeConstantGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeIfazeConstantGeneralization/DataTypeIfazeConstantGeneralization/FIELD1|,
		|java+field:///testing_lib/dataTypeIfazeConstantGeneralization/DataTypeIfazeConstantGeneralization/FIELD1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;