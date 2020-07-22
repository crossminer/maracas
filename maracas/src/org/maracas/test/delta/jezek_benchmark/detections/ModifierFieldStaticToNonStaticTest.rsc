module org::maracas::\test::delta::jezek_benchmark::detections::ModifierFieldStaticToNonStaticTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

test bool occurrence()
	= containsCase("modifierFieldStaticToNonStatic");
	
test bool staticAccess()
	= detection(
		|java+method:///modifierFieldStaticToNonStatic/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/modifierFieldStaticToNonStatic/ModifierFieldStaticToNonStatic/field1|,
		|java+field:///testing_lib/modifierFieldStaticToNonStatic/ModifierFieldStaticToNonStatic/field1|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;