module org::maracas::\test::delta::jezek_benchmark::detections::ModifierFieldNonStaticToStaticTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool nonStaticAccess()
	= detection(
		|java+method:///modifierFieldNonStaticToStatic/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/modifierFieldNonStaticToStatic/ModifierFieldNonStaticToStatic/field1|,
		|java+field:///testing_lib/modifierFieldNonStaticToStatic/ModifierFieldNonStaticToStatic/field1|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;