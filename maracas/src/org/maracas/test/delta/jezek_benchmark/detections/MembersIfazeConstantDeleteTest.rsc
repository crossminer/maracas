module org::maracas::\test::delta::jezek_benchmark::detections::MembersIfazeConstantDeleteTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// Cannot detect changes in constants (they are inlined in the bytecode)
test bool occurrence()
	= containsCase("membersIfazeConstantDelete") == true;