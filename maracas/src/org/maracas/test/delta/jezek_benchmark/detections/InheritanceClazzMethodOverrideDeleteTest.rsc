module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceClazzMethodOverrideDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= !containsCase("inheritanceClazzMethodMovedToSuperClass");

test bool methRem()
	= detection(
		|java+method:///inheritanceClazzMethodMovedToSuperClass/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/inheritanceClazzMethodMovedToSuperClass/InheritanceClazzMethodOverrideDelete/method1()|,
		|java+method:///testing_lib/inheritanceClazzMethodMovedToSuperClass/InheritanceClazzMethodOverrideDelete/method1()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;