module org::maracas::\test::delta::jezek_benchmark::detections::OtherClazzAddTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= containsCase("otherClazzAdd") == false;