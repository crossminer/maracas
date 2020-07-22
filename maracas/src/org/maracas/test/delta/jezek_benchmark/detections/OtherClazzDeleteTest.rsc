module org::maracas::\test::delta::jezek_benchmark::detections::OtherClazzDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("otherClazzDelete");
	
test bool depClass()
	= detection(
		|java+method:///otherClazzDelete/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/otherClazzDelete/OtherClazzDelete|,
		|java+class:///testing_lib/otherClazzDelete/OtherClazzDelete|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool consRem()
	= detection(
		|java+method:///otherClazzDelete/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/otherClazzDelete/OtherClazzDelete/OtherClazzDelete()|,
		|java+constructor:///testing_lib/otherClazzDelete/OtherClazzDelete/OtherClazzDelete()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;