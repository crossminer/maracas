module org::maracas::\test::delta::jezek_benchmark::detections::ExceptionClazzMethodThrowCheckedAddTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool checkedAdd()
	= detection(
		|java+method:///exceptionClazzMethodThrowCheckedAdd/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/exceptionClazzMethodThrowCheckedAdd/ExceptionClazzMethodThrowCheckedAdd/method1()|,
		|java+method:///testing_lib/exceptionClazzMethodThrowCheckedAdd/ExceptionClazzMethodThrowCheckedAdd/method1()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;