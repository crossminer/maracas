module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedClazzAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

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