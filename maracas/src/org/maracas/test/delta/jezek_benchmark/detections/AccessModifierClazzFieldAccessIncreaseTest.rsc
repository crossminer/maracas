module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessIncreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here

test bool protectedToPublic()
	= detection(
		|java+method:///accessModifierClazzFieldAccessIncrease/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessIncrease/Main/fieldProtectedToPublic|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessIncrease/AccessModifierClazzFieldAccessIncrease/fieldProtectedToPublic|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;