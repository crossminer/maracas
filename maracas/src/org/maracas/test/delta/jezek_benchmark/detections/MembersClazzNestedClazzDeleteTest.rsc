module org::maracas::\test::delta::jezek_benchmark::detections::MembersClazzNestedClazzDeleteTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool classRem()
	= detection(
		|java+method:///membersClazzNestedClazzDelete/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/membersClazzNestedClazzDelete/MembersClazzNestedClazzDelete$NestedClazz|,
		|java+class:///testing_lib/membersClazzNestedClazzDelete/MembersClazzNestedClazzDelete$NestedClazz|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool consRem()
	= detection(
		|java+method:///membersClazzNestedClazzDelete/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/membersClazzNestedClazzDelete/MembersClazzNestedClazzDelete$NestedClazz/MembersClazzNestedClazzDelete$NestedClazz(testing_lib.membersClazzNestedClazzDelete.MembersClazzNestedClazzDelete)|,
		|java+constructor:///testing_lib/membersClazzNestedClazzDelete/MembersClazzNestedClazzDelete$NestedClazz/MembersClazzNestedClazzDelete$NestedClazz(testing_lib.membersClazzNestedClazzDelete.MembersClazzNestedClazzDelete)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;