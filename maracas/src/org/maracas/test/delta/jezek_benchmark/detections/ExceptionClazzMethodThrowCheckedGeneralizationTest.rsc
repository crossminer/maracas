module org::maracas::\test::delta::jezek_benchmark::detections::ExceptionClazzMethodThrowCheckedGeneralizationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool excepGen()
	= detection(
		|java+method:///exceptionClazzMethodThrowCheckedGeneralization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/exceptionClazzMethodThrowCheckedGeneralization/ExceptionClazzMethodThrowCheckedGeneralization/method1()|,
		|java+method:///testing_lib/exceptionClazzMethodThrowCheckedGeneralization/ExceptionClazzMethodThrowCheckedGeneralization/method1()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;