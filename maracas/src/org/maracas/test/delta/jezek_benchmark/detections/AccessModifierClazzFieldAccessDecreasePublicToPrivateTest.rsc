module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessDecreasePublicToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzFieldAccessDecreasePublicToPrivate");
	
test bool publicToPrivate()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecreasePublicToPrivate/Main/fieldPublicToPrivate|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToPrivate/AccessModifierClazzFieldAccessDecreasePublicToPrivate/fieldPublicToPrivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToPrivateSuper()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToPrivate/AccessModifierClazzFieldAccessDecreasePublicToPrivate/fieldPublicToPrivate|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecreasePublicToPrivate/AccessModifierClazzFieldAccessDecreasePublicToPrivate/fieldPublicToPrivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;