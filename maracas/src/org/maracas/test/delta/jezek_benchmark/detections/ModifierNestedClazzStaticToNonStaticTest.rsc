module org::maracas::\test::delta::jezek_benchmark::detections::ModifierNestedClazzStaticToNonStaticTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool noCons()
	= detection(
		|java+method:///modifierNestedClazzStaticToNonStatic/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/modifierNestedClazzStaticToNonStatic/ModifierNestedClazzStaticToNonStatic$NestedClazz/ModifierNestedClazzStaticToNonStatic$NestedClazz()|,
		|java+constructor:///testing_lib/modifierNestedClazzStaticToNonStatic/ModifierNestedClazzStaticToNonStatic$NestedClazz/ModifierNestedClazzStaticToNonStatic$NestedClazz()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;