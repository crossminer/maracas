module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzMethodAccessDecrease") == true;
	
test bool publicToProtected()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodPublicToProtected()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodPublicToProtected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool publicToNon()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodPublicToNon()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodPublicToNon()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool publicToPrivate()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodPublicToPrivate()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodPublicToPrivate()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool protectedToNon()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/methodProtectedToNon()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodProtectedToNon()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool protectedToPrivate()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecrease/Main/methodProtectedToPrivate()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecrease/AccessModifierClazzMethodAccessDecrease/methodProtectedToPrivate()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;