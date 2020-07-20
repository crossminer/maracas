module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessDecreasePublicToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzFieldAccessDecreasePublicToNon");
	
test bool publicToNon()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecreasePublicToNon/Main/fieldPublicToNon|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToNon/AccessModifierClazzFieldAccessDecreasePublicToNon/fieldPublicToNon|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
 
test bool publicToNonSuper()   
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToNon/AccessModifierClazzFieldAccessDecreasePublicToNon/fieldPublicToNon|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToNon/AccessModifierClazzFieldAccessDecreasePublicToNon/fieldPublicToNon|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;