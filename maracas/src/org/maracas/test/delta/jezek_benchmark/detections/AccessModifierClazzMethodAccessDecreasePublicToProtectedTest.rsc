module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessDecreasePublicToProtectedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzMethodAccessDecreasePublicToProtected");
	
test bool publicToProtected()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToProtected/Main/methodPublicToProtected()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToProtected/AccessModifierClazzMethodAccessDecreasePublicToProtected/methodPublicToProtected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool publicToProtectedSuper()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToProtected/AccessModifierClazzMethodAccessDecreasePublicToProtected/methodPublicToProtected()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToProtected/AccessModifierClazzMethodAccessDecreasePublicToProtected/methodPublicToProtected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;