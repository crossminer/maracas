module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzConstructorAccessIncreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// [ORACLE] No BC to report here

test bool protectedToPublic()
	= detection(
		|java+constructor:///accessModifierClazzConstructorAccessIncrease/Main/Main(int,int,int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessIncrease/AccessModifierClazzConstructorAccessIncrease/AccessModifierClazzConstructorAccessIncrease(int,int,int,int,int)|,
		|java+constructor:///testing_lib/accessModifierClazzConstructorAccessIncrease/AccessModifierClazzConstructorAccessIncrease/AccessModifierClazzConstructorAccessIncrease(int,int,int,int,int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;