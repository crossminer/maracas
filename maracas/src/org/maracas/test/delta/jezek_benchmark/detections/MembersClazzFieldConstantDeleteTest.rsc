module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzFieldConstantDeleteTest

import org::maracas::\test::delta::jezek_benchmark::detections::Common;


// Cannot detect changes in constants (they are inlined in the bytecode)
test bool occurrence()
	= containsCase("membersClazzFieldConstantDelete") == true;