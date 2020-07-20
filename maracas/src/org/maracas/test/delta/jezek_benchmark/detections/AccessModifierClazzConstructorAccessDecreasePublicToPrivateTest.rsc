module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreasePublicToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzConstructorAccessDecreasePublicToPrivate");
	
test bool cons()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecreasePublicToPrivate/Main/Main(int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate(int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate(int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool main() 
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecreasePublicToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate(int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate/AccessModifierClazzConstructorAccessDecreasePublicToPrivate(int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;