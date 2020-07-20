module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedClazzAccessDecreasePublicToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedClazzAccessDecreasePublicToNon");

test bool lessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToNon/AccessModifierClazzNestedClazzAccessDecreasePublicToNon$ClazzPublicToNon|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToNon/AccessModifierClazzNestedClazzAccessDecreasePublicToNon$ClazzPublicToNon|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool noLongPub()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToNon/AccessModifierClazzNestedClazzAccessDecreasePublicToNon$ClazzPublicToNon|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToNon/AccessModifierClazzNestedClazzAccessDecreasePublicToNon$ClazzPublicToNon|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;