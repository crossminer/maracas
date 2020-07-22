module org::maracas::\test::delta::jezek_benchmark::detections::ModifierNestedClazzNonStaticToStaticTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("modifierNestedClazzNonStaticToStatic");
	
test bool noCons()
	= detection(
		|java+method:///modifierNestedClazzNonStaticToStatic/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/modifierNestedClazzNonStaticToStatic/ModifierNestedClazzNonStaticToStatic$NestedClazz/ModifierNestedClazzNonStaticToStatic$NestedClazz(testing_lib.modifierNestedClazzNonStaticToStatic.ModifierNestedClazzNonStaticToStatic)|,
		|java+constructor:///testing_lib/modifierNestedClazzNonStaticToStatic/ModifierNestedClazzNonStaticToStatic$NestedClazz/ModifierNestedClazzNonStaticToStatic$NestedClazz(testing_lib.modifierNestedClazzNonStaticToStatic.ModifierNestedClazzNonStaticToStatic)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;