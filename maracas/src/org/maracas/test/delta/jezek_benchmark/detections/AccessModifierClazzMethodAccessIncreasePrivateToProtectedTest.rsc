module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessIncreasePrivateToProtectedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= !containsCase("accessModifierClazzMethodAccessIncreasePrivateToProtected");