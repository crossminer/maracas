module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedIfazeAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedIfazeAccessDecrease");
	
test bool publicToNon()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToNonLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool publicToNonLessAccImpl() 
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToNonImpl()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToNon|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToPrivateLessAccImpl()  
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToPrivateImpl()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToPrivate()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToPrivateLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToPrivate|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToProtected()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToProtectedLessAcc()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToProtectedLessAccImpl()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToProtectedImpl()
	= detection(
		|java+class:///accessModifierClazzNestedIfazeAccessDecrease/Main|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		|java+interface:///testing_lib/accessModifierClazzNestedIfazeAccessDecrease/AccessModifierClazzNestedIfazeAccessDecrease$IfazePublicToProtected|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;