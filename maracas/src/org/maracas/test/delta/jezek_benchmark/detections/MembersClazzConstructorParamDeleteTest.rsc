module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzConstructorParamDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersClazzConstructorParamDelete");
	
// It is reported as a constructorRemoved change
test bool remParam()
	= detection(
		|java+method:///membersClazzConstructorParamDelete/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/membersClazzConstructorParamDelete/MembersClazzConstructorParamDelete/MembersClazzConstructorParamDelete(java.lang.Integer,java.lang.String)|,
		|java+constructor:///testing_lib/membersClazzConstructorParamDelete/MembersClazzConstructorParamDelete/MembersClazzConstructorParamDelete(java.lang.Integer,java.lang.String)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;