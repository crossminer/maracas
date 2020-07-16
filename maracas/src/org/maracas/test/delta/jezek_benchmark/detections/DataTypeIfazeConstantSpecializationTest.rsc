module org::maracas::\test::delta::jezek_benchmark::detections::DataTypeIfazeConstantSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("dataTypeIfazeConstantSpecialization") == true;
	
test bool consSpec()
	= detection(
		|java+method:///dataTypeIfazeConstantSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/dataTypeIfazeConstantSpecialization/DataTypeIfazeConstantSpecialization/FIELD1|,
		|java+field:///testing_lib/dataTypeIfazeConstantSpecialization/DataTypeIfazeConstantSpecialization/FIELD1|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;