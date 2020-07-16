module org::maracas::\test::delta::jezek_benchmark::detections::ModifierFieldFinalToNonFinalTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= containsCase("modifierFieldFinalToNonFinal") == false;