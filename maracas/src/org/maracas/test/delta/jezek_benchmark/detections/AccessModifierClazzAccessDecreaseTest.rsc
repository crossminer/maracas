module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzAccessDecrease");

test bool classNoLongPub()
	= detection(
		|java+method:///accessModifierClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease|,
		|java+class:///testing_lib/accessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease|,
		typeDependency(), 
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool classLessAcc()
	= detection(
		|java+method:///accessModifierClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/accessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease|,
		|java+class:///testing_lib/accessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool consLessAcc()
	= detection(
		|java+method:///accessModifierClazzAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease()|,
		|java+constructor:///testing_lib/accessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease/AccessModifierClazzAccessDecrease()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;