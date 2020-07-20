module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessDecreasePublicToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzMethodAccessDecreasePublicToPrivate");
	
test bool publicToPrivate()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToPrivate/Main/methodPublicToPrivate()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToPrivate/AccessModifierClazzMethodAccessDecreasePublicToPrivate/methodPublicToPrivate()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToPrivateSuper()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToPrivate/AccessModifierClazzMethodAccessDecreasePublicToPrivate/methodPublicToPrivate()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToPrivate/AccessModifierClazzMethodAccessDecreasePublicToPrivate/methodPublicToPrivate()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;