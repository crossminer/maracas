module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierIfazeMethodAccessIncreaseTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// [ORACLE] No BC to report here
// By default, methods within an interface are public
test bool noOccurrence()
	= !containsCase("accessModifierIfazeMethodAccessIncrease");