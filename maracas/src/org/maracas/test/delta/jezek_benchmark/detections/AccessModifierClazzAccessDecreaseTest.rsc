module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzAccessDecreasetTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


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