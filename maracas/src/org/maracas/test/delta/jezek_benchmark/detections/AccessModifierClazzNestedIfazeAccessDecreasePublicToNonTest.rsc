module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedIfazeAccessDecreasePublicToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedIfazeAccessDecreasePublicToNon");

test bool depNoLongPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToNon/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool depLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToNon/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impNoLongPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToNon/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToNon/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToNon/AccessModifierClazzNestedIfazeAccessDecreasePublicToNon$IfazePublicToNon|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;