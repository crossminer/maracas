module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzMethodParamAddTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersClazzMethodParamAdd");
	
// It is reported as a methodRemoved change
test bool paramAdd()
	= detection(
		|java+method:///membersClazzMethodParamAdd/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/membersClazzMethodParamAdd/MembersClazzMethodParamAdd/method1()|,
		|java+method:///testing_lib/membersClazzMethodParamAdd/MembersClazzMethodParamAdd/method1()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;