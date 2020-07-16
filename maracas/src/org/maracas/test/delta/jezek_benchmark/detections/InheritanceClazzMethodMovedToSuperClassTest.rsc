module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceClazzMethodMovedToSuperClassTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

// [ORACLE] No BC to report here


test bool methRem()
	= detection(
		|java+method:///inheritanceClazzMethodMovedToSuperClass/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/inheritanceClazzMethodMovedToSuperClass/Clazz1/method1()|,
		|java+method:///testing_lib/inheritanceClazzMethodMovedToSuperClass/Clazz1/method1()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;