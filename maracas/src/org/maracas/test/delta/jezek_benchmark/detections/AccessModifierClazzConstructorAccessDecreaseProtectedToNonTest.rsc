module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreaseProtectedToNonTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzConstructorAccessDecreaseProtectedToNon");
	
test bool cons()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecreaseProtectedToNon/Main/Main(int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon(int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon(int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// No reference on client
test bool main() 
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecreaseProtectedToNon/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon(int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon/AccessModifierClazzConstructorAccessDecreaseProtectedToNon(int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;