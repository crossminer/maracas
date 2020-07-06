module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzConstructorParamAddTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// It is reported as a constructorRemoved change
test bool addParam()
	= detection(
		|java+method:///membersClazzConstructorParamAdd/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/membersClazzConstructorParamAdd/MembersClazzConstructorParamAdd/MembersClazzConstructorParamAdd(java.lang.Integer)|,
		|java+constructor:///testing_lib/membersClazzConstructorParamAdd/MembersClazzConstructorParamAdd/MembersClazzConstructorParamAdd(java.lang.Integer)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;