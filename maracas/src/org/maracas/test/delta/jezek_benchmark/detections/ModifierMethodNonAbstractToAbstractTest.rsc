module org::maracas::\test::delta::jezek_benchmark::detections::ModifierMethodNonAbstractToAbstractTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("modifierMethodNonAbstractToAbstract");
	
test bool extAbstract()
	= detection(
		|java+class:///modifierMethodNonAbstractToAbstract/Main|,
		|java+class:///testing_lib/modifierMethodNonAbstractToAbstract/ModifierMethodNonAbstractToAbstract|,
		|java+method:///testing_lib/modifierMethodNonAbstractToAbstract/ModifierMethodNonAbstractToAbstract/method1()|,
		extends(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool invAbsMeth()
	= detection(
		|java+method:///modifierMethodNonAbstractToAbstract/Main/main(java.lang.String%5B%5D)|,
		|java+method:///modifierMethodNonAbstractToAbstract/Main/method1()|,
		|java+method:///testing_lib/modifierMethodNonAbstractToAbstract/ModifierMethodNonAbstractToAbstract/method1()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;