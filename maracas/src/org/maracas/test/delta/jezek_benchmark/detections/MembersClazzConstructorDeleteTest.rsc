module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzConstructorDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersClazzConstructorDelete") == true;
	
test bool consRem()
	= detection(
		|java+method:///membersClazzConstructorDelete/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/membersClazzConstructorDelete/MembersClazzConstructorDelete/MembersClazzConstructorDelete(int)|,
		|java+constructor:///testing_lib/membersClazzConstructorDelete/MembersClazzConstructorDelete/MembersClazzConstructorDelete(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
    
    