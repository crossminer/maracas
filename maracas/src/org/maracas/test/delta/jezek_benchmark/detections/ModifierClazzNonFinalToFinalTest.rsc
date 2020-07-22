module org::maracas::\test::delta::jezek_benchmark::detections::ModifierClazzNonFinalToFinalTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("modifierClazzNonFinalToFinal");
	
test bool extFinal()
	= detection(
		|java+class:///modifierClazzNonFinalToFinal/Main|,
		|java+class:///testing_lib/modifierClazzNonFinalToFinal/ModifierClazzNonFinalToFinal|,
		|java+class:///testing_lib/modifierClazzNonFinalToFinal/ModifierClazzNonFinalToFinal|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;