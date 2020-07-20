module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessDecreaseProtectedToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzFieldAccessDecreaseProtectedToPrivate");
	
test bool protectedToPrivate()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreaseProtectedToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecreaseProtectedToPrivate/Main/fieldProtectedToPrivate|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreaseProtectedToPrivate/AccessModifierClazzFieldAccessDecreaseProtectedToPrivate/fieldProtectedToPrivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;