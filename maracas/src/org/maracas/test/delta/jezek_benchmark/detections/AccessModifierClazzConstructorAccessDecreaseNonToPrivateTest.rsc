module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreaseNonToPrivateTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here
test bool noOccurrence()
	= !containsCase("accessModifierClazzConstructorAccessDecreaseNonToPrivate");
	
test bool cons()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecreaseNonToPrivate/Main/Main()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// No reference in client
test bool main() 
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecreaseNonToPrivate/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate/AccessModifierClazzConstructorAccessDecreaseNonToPrivate()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;