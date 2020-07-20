module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzMethodAccessDecreasePublicToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzMethodAccessDecreasePublicToNon");
	
test bool publicToNon()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToNon/Main/methodPublicToNon()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToNon/AccessModifierClazzMethodAccessDecreasePublicToNon/methodPublicToNon()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool publicToNonSuper()
	= detection(
		|java+method:///accessModifierClazzMethodAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToNon/AccessModifierClazzMethodAccessDecreasePublicToNon/methodPublicToNon()|,
		|java+method:///testing_lib/accessModifierClazzMethodAccessDecreasePublicToNon/AccessModifierClazzMethodAccessDecreasePublicToNon/methodPublicToNon()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;