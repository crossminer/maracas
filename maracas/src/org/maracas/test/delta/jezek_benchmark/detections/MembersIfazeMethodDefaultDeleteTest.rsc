module org::maracas::\test::delta::jezek_benchmark::detections::MembersIfazeMethodDefaultDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool methRem()
	 = detection(
	 	|java+method:///membersIfazeMethodDefaultDelete/Main/main(java.lang.String%5B%5D)|,
	 	|java+method:///testing_lib/membersIfazeMethodDefaultDelete/MembersIfazeMethodDefaultDelete/method1()|,
	 	|java+method:///testing_lib/membersIfazeMethodDefaultDelete/MembersIfazeMethodDefaultDelete/method1()|,
	 	methodInvocation(),
	 	methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	 in detects;