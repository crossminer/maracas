module org::maracas::\test::delta::jezek_benchmark::detections::ModifierFieldNonFinalToFinalTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("modifierFieldNonFinalToFinal");
	
test bool assignFinal()
	= detection(
		|java+method:///modifierFieldNonFinalToFinal/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/modifierFieldNonFinalToFinal/ModifierFieldNonFinalToFinal/field1|,
		|java+field:///testing_lib/modifierFieldNonFinalToFinal/ModifierFieldNonFinalToFinal/field1|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;