module org::maracas::\test::delta::jezek_benchmark::detections::ModifierMethodStaticToNonStaticTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool staticInv()
	= detection(
		|java+method:///modifierMethodStaticToNonStatic/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/modifierMethodStaticToNonStatic/ModifierMethodStaticToNonStatic/method1()|,
		|java+method:///testing_lib/modifierMethodStaticToNonStatic/ModifierMethodStaticToNonStatic/method1()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;