module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzMethodDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool methRem()
	= detection(
		|java+method:///membersClazzMethodDelete/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/membersClazzMethodDelete/MembersClazzMethodDelete/method1()|,
		|java+method:///testing_lib/membersClazzMethodDelete/MembersClazzMethodDelete/method1()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;