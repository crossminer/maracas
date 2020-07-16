module org::maracas::\test::delta::jezek_benchmark::detections::ExceptionClazzMethodThrowUncheckedDeleteTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= containsCase("exceptionClazzMethodThrowUncheckedDelete") == false;