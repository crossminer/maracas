module org::maracas::\test::delta::jezek_benchmark::detections::OtherClazzToIfazeTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("otherClazzToIfaze") == true;
	
// TODO: classTypeChanged?
test bool classAbs()
	= detection(
		|java+method:///otherClazzToIfaze/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/otherClazzToIfaze/ClazzToIfaze/ClazzToIfaze()|,
		|java+class:///testing_lib/otherClazzToIfaze/ClazzToIfaze|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool consRem()
	= detection(
		|java+method:///otherClazzToIfaze/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/otherClazzToIfaze/ClazzToIfaze/ClazzToIfaze()|,
		|java+constructor:///testing_lib/otherClazzToIfaze/ClazzToIfaze/ClazzToIfaze()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;