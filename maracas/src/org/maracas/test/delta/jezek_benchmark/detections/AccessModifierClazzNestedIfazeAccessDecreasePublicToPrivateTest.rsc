module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate");
	
test bool depNoLongPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool depLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impNoLongPub()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool impLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecreasePublicToPrivate/AccessModifierClazzNestedIfazeAccessDecreasePublicToPrivate$IfazePublicToPrivate|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;