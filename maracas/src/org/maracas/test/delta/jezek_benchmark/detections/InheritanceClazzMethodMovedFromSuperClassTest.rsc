module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceClazzMethodMovedFromSuperClassTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("inheritanceClazzMethodMovedFromSuperClass") == true;
	
test bool methRem()
	= detection(
		|java+method:///inheritanceClazzMethodMovedFromSuperClass/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/inheritanceClazzMethodMovedFromSuperClass/Clazz1/method1()|,
		|java+method:///testing_lib/inheritanceClazzMethodMovedFromSuperClass/Clazz1/method1()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;