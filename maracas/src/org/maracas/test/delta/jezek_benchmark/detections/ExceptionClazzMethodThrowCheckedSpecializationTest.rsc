module org::maracas::\test::delta::jezek_benchmark::detections::ExceptionClazzMethodThrowCheckedSpecializationTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

// [ORACLE] No BC to report here
test bool noOccurrence()
	= !containsCase("exceptionClazzMethodThrowCheckedSpecialization");

test bool excepSepc()
	= detection(
		|java+method:///exceptionClazzMethodThrowCheckedSpecialization/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/exceptionClazzMethodThrowCheckedSpecialization/ExceptionClazzMethodThrowCheckedSpecialization/method1()|,
		|java+method:///testing_lib/exceptionClazzMethodThrowCheckedSpecialization/ExceptionClazzMethodThrowCheckedSpecialization/method1()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;