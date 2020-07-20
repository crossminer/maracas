module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessDecreaseProtectedToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzMethodAccessDecreaseProtectedToPrivate");
	
test bool protectedToPrivate()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreaseProtectedToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecreaseProtectedToPrivate/Main/methodProtectedToPrivate()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreaseProtectedToPrivate/AccessModifierClazzMethodAccessDecreaseProtectedToPrivate/methodProtectedToPrivate()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	