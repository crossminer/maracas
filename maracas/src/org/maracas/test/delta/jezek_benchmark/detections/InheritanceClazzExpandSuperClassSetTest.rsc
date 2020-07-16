module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceClazzExpandSuperClassSetTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

// [ORACLE] No BC to report here

// Non-breaking usage
test bool expandSuper()
	= detection(
		|java+class:///inheritanceClazzExpandSuperClassSet/Main|,
		|java+class:///testing_lib/inheritanceClazzExpandSuperClassSet/Clazz1|,
		|java+class:///testing_lib/inheritanceClazzExpandSuperClassSet/Clazz1|,
		extends(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;