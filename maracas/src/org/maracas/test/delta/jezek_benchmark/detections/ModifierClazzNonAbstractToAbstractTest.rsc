module org::maracas::\test::delta::jezek_benchmark::detections::ModifierClazzNonAbstractToAbstractTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool mainRef()
	 = detection(
	 	|java+method:///modifierClazzNonAbstractToAbstract/Main/main(java.lang.String%5B%5D)|,
	 	|java+constructor:///testing_lib/modifierClazzNonAbstractToAbstract/ModifierClazzNonAbstractToAbstract/ModifierClazzNonAbstractToAbstract()|,
	 	|java+class:///testing_lib/modifierClazzNonAbstractToAbstract/ModifierClazzNonAbstractToAbstract|,
	 	methodInvocation(),
	 	classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	 in detects;