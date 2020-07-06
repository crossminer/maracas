module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzMethodAbstractAddTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool methAbsAdd()
	= detection(
		|java+class:///membersClazzMethodAbstractAdd/Main|,
		|java+class:///testing_lib/membersClazzMethodAbstractAdd/MembersClazzMethodAbstractAdd|,
		|java+method:///testing_lib/membersClazzMethodAbstractAdd/MembersClazzMethodAbstractAdd/method1()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;