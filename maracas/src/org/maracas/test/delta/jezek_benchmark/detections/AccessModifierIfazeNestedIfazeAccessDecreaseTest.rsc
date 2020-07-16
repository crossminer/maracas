module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierIfazeNestedIfazeAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= containsCase("accessModifierClazzNestedIfazeAccessDecrease") == false;

test bool publicToNonLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToNonNoPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
// TODO: missing reference on main() method