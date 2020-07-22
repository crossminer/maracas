module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceIfazeContractSuperinterfaceSetTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// TODO: method override method2
test bool occurrence()
	= containsCase("inheritanceIfazeContractSuperinterfaceSet");
	
test bool methRem()
	 = detection(
	 	|java+method:///inheritanceIfazeContractSuperinterfaceSet/Main/main(java.lang.String%5B%5D)|,
	 	|java+method:///testing_lib/inheritanceIfazeContractSuperinterfaceSet/Interface2/ifaze2method1()|,
	 	|java+method:///testing_lib/inheritanceIfazeContractSuperinterfaceSet/Interface2/ifaze2method1()|,
	 	methodInvocation(),
	 	methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	 in detects;