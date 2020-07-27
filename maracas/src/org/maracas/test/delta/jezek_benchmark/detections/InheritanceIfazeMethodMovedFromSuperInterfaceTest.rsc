module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceIfazeMethodMovedFromSuperInterfaceTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= !containsCase("inheritanceIfazeMethodMovedFromSuperInterface");

test bool methRem()
	= detection(
		|java+method:///inheritanceIfazeMethodMovedFromSuperInterface/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/inheritanceIfazeMethodMovedFromSuperInterface/InheritanceIfazeMethodMovedFromSuperInterface/method1()|,
		|java+method:///testing_lib/inheritanceIfazeMethodMovedFromSuperInterface/Interface1/method1()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
    
test bool methAdd()
	= detection(
		|java+class:///inheritanceIfazeMethodMovedFromSuperInterface/Main|,
		|java+interface:///testing_lib/inheritanceIfazeMethodMovedFromSuperInterface/InheritanceIfazeMethodMovedFromSuperInterface|,
		|java+method:///testing_lib/inheritanceIfazeMethodMovedFromSuperInterface/InheritanceIfazeMethodMovedFromSuperInterface/method1()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;