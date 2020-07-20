module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedIfazeAccessDecreasePublicToProtectedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedIfazeAccessDecreasePublicToProtected");
	
test bool depNoLongPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool depLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impNoLongPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToProtected/AccessModifierClazzNestedIfazeAccessDecreasePublicToProtected$IfazePublicToProtected|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;