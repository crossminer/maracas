module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzMethodParamDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersClazzMethodParamDelete") == true;
	
// It is reported as a methodRemoved change
test bool paramRem()
	= detection(
		|java+method:///membersClazzMethodParamDelete/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/membersClazzMethodParamDelete/MembersClazzMethodParamDelete/method1(java.lang.Integer)|,
		|java+method:///testing_lib/membersClazzMethodParamDelete/MembersClazzMethodParamDelete/method1(java.lang.Integer)|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;