module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessDecreasePublicToProtectedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzFieldAccessDecreasePublicToProtected");
	
test bool publicToProtected()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecreasePublicToProtected/Main/fieldPublicToProtected|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToProtected/AccessModifierClazzFieldAccessDecreasePublicToProtected/fieldPublicToProtected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool publicToProtectedSuper()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToProtected/AccessModifierClazzFieldAccessDecreasePublicToProtected/fieldPublicToProtected|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToProtected/AccessModifierClazzFieldAccessDecreasePublicToProtected/fieldPublicToProtected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;