module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceIfazeMethodMovedToSuperInterfaceTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// TODO: this shouldn'y be reported as a detection
test bool newMethInter()
	 = detection(
	 	|java+class:///inheritanceIfazeMethodMovedToSuperInterface/Main|,
	 	|java+interface:///testing_lib/inheritanceIfazeMethodMovedToSuperInterface/InheritanceIfazeMethodMovedToSuperInterface|,
	 	|java+method:///testing_lib/inheritanceIfazeMethodMovedToSuperInterface/Interface1/method1()|,
	 	implements(),
	 	methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	 notin detects;