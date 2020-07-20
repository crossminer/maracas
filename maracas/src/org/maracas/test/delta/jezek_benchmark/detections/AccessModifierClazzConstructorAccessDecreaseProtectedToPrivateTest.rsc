module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreaseProtectedToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzConstructorAccessDecreaseProtectedToPrivate");
	
test bool cons()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecreaseProtectedToPrivate/Main/Main(int,int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate(int,int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate(int,int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// No reference on client
test bool main() 
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecreaseProtectedToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate(int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate/AccessModifierClazzConstructorAccessDecreaseProtectedToPrivate(int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;