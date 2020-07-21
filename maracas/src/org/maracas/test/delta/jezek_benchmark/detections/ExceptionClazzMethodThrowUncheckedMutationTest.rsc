module org::maracas::\test::delta::jezek_benchmark::detections::ExceptionClazzMethodThrowUncheckedMutationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("exceptionClazzMethodThrowUncheckedMutation");

test bool excepMut()
	= detection(
		|java+method:///exceptionClazzMethodThrowUncheckedMutation/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/exceptionClazzMethodThrowUncheckedMutation/ExceptionClazzMethodThrowUncheckedMutation/method1()|,
		|java+method:///testing_lib/exceptionClazzMethodThrowUncheckedMutation/ExceptionClazzMethodThrowUncheckedMutation/method1()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;