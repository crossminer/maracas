module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreasePublicToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzConstructorAccessDecreasePublicToNon");

test bool cons()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecreasePublicToNon/Main/Main(int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon(int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool main()
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecreasePublicToNon/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon(int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon/AccessModifierClazzConstructorAccessDecreasePublicToNon(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;