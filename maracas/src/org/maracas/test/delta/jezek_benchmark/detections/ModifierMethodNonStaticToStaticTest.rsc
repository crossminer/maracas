module org::maracas::\test::delta::jezek_benchmark::detections::ModifierMethodNonStaticToStaticTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("modifierMethodNonStaticToStatic") == true;
	
test bool nonStaticAccess()
	= detection(
		|java+method:///modifierMethodNonStaticToStatic/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/modifierMethodNonStaticToStatic/ModifierMethodNonStaticToStatic/method1()|,
		|java+method:///testing_lib/modifierMethodNonStaticToStatic/ModifierMethodNonStaticToStatic/method1()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;