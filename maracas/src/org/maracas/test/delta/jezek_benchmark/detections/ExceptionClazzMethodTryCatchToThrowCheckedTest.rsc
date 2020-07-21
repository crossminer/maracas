module org::maracas::\test::delta::jezek_benchmark::detections::ExceptionClazzMethodTryCatchToThrowCheckedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("exceptionClazzMethodTryCatchToThrowChecked");
	
test bool excepCheck()
	= detection(
		|java+method:///exceptionClazzMethodTryCatchToThrowChecked/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/exceptionClazzMethodTryCatchToThrowChecked/ExceptionClazzMethodTryCatchToThrowChecked/method1(java.io.File)|,
		|java+method:///testing_lib/exceptionClazzMethodTryCatchToThrowChecked/ExceptionClazzMethodTryCatchToThrowChecked/method1(java.io.File)|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;