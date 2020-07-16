module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzFieldDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("membersClazzFieldDelete") == true;
	
test bool remField()
	= detection(
		|java+method:///membersClazzFieldDelete/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/membersClazzFieldDelete/MembersClazzFieldDelete/field1|,
		|java+field:///testing_lib/membersClazzFieldDelete/MembersClazzFieldDelete/field1|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;