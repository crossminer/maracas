module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessDecreaseProtectedToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzMethodAccessDecreaseProtectedToNon");

test bool protectedToNon()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreaseProtectedToNon/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecreaseProtectedToNon/Main/methodProtectedToNon()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreaseProtectedToNon/AccessModifierClazzMethodAccessDecreaseProtectedToNon/methodProtectedToNon()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;