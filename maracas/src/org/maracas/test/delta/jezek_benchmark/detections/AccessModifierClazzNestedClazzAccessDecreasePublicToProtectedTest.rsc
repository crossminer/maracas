module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzNestedClazzAccessDecreasePublicToProtectedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzNestedClazzAccessDecreasePublicToProtected");
	
test bool lessAcc()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToProtected/AccessModifierClazzNestedClazzAccessDecreasePublicToProtected$ClazzPublicToProtected|,
		|java+class:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToProtected/AccessModifierClazzNestedClazzAccessDecreasePublicToProtected$ClazzPublicToProtected|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool noLongPub()
	= detection(
		|java+method:///accessModifierClazzNestedClazzAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToProtected/AccessModifierClazzNestedClazzAccessDecreasePublicToProtected$ClazzPublicToProtected/AccessModifierClazzNestedClazzAccessDecreasePublicToProtected$ClazzPublicToProtected(testing_lib.accessModifierClazzNestedClazzAccessDecreasePublicToProtected.AccessModifierClazzNestedClazzAccessDecreasePublicToProtected)|,
		|java+constructor:///testing_lib/accessModifierClazzNestedClazzAccessDecreasePublicToProtected/AccessModifierClazzNestedClazzAccessDecreasePublicToProtected$ClazzPublicToProtected/AccessModifierClazzNestedClazzAccessDecreasePublicToProtected$ClazzPublicToProtected(testing_lib.accessModifierClazzNestedClazzAccessDecreasePublicToProtected.AccessModifierClazzNestedClazzAccessDecreasePublicToProtected)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;