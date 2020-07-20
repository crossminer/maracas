module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreasePublicToProtectedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzConstructorAccessDecreasePublicToProtected");
	
test bool cons()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecreasePublicToProtected/Main/Main()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool main() 
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecreasePublicToProtected/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected/AccessModifierClazzConstructorAccessDecreasePublicToProtected()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;