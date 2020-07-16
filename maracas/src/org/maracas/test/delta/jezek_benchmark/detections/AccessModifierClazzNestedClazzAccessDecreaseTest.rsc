module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedClazzAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

    
test bool occurrence()
	= containsCase("accessModifierClazzNestedClazzAccessDecrease") == true;
	
// TODO: check
test bool publicToProtected()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToProtectedLessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToPrivate()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool publicToPrivateLessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToNon()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToNon|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToNon|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToNonLessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToNon|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToNon|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool consPublicToPrivateLessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate(testing_lib.accessModifierClazzNestedClazzAccessDecrease.AccessModifierClazzNestedClazzAccessDecrease)|,
		|java+constructor:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToPrivate(testing_lib.accessModifierClazzNestedClazzAccessDecrease.AccessModifierClazzNestedClazzAccessDecrease)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: check
test bool consPublicToProtectedLessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected(testing_lib.accessModifierClazzNestedClazzAccessDecrease.AccessModifierClazzNestedClazzAccessDecrease)|,
		|java+constructor:///testing_lib/accessModifierClazzNestedClazzAccessDecrease/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected/AccessModifierClazzNestedClazzAccessDecrease$ClazzPublicToProtected(testing_lib.accessModifierClazzNestedClazzAccessDecrease.AccessModifierClazzNestedClazzAccessDecrease)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;