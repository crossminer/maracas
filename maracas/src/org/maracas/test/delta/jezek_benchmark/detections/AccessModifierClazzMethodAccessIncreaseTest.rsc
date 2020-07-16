module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessIncreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= containsCase("accessModifierClazzMethodAccessIncrease") == false;
	
test bool protectedToPublic()
	= detection(
		|java+method:///accessModifierClazzMethodAccessIncrease/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessIncrease/Main/methodProtectedToPublic()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessIncrease/AccessModifierClazzMethodAccessIncrease/methodProtectedToPublic()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;