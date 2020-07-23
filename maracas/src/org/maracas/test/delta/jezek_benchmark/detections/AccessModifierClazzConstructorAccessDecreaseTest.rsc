module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzConstructorAccessDecrease") == true;

// protected to private
test bool superInvThreeArgs()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecrease/Main/Main(int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// protected to non
test bool superInvFourArgs()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessDecrease/Main/Main(int,int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int,int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int,int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// public to protected
test bool invNoArg()
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease()|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// public to non
test bool invOneArg()
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// public to private
test bool invTwoArgs()
	= detection(
		|java+method:///accessModifierClazzConstructorAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease/AccessModifierClazzConstructorAccessDecrease(int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;