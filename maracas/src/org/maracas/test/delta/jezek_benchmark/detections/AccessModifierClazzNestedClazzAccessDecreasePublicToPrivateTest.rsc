module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedClazzAccessDecreasePublicToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedClazzAccessDecreasePublicToPrivate");

test bool lessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToPrivate/AccessModifierClazzNestedClazzAccessDecreasePublicToPrivate$ClazzPublicToPrivate|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToPrivate/AccessModifierClazzNestedClazzAccessDecreasePublicToPrivate$ClazzPublicToPrivate|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool noLongPub()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToPrivate/AccessModifierClazzNestedClazzAccessDecreasePublicToPrivate$ClazzPublicToPrivate|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToPrivate/AccessModifierClazzNestedClazzAccessDecreasePublicToPrivate$ClazzPublicToPrivate|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;