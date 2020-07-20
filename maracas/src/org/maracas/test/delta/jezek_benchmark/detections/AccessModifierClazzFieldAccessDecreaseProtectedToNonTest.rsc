module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessDecreaseProtectedToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzFieldAccessDecreaseProtectedToNon");

test bool protectedToNon()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreaseProtectedToNon/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecreaseProtectedToNon/Main/fieldProtectedToNon|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreaseProtectedToNon/AccessModifierClazzFieldAccessDecreaseProtectedToNon/fieldProtectedToNon|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;