module org::maracas::\test::delta::jezek_benchmark::detections::ModifierFieldNonTransientToTransientTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// [ORACLE] No BC to report here
// This case is not considered in the delta
test bool noOccurrence()
	= !containsCase("modifierFieldNonTransientToTransient");