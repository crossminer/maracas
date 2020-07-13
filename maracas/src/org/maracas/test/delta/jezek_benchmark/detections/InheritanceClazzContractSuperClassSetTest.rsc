module org::maracas::\test::delta::jezek_benchmark::detections::InheritanceClazzContractSuperClassSetTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


// Non-breaking usage
test bool contractSuper()
	= detection(
		|java+class:///inheritanceClazzContractSuperClassSet/Main|,
		|java+class:///testing_lib/inheritanceClazzContractSuperClassSet/Clazz2|,
		|java+class:///testing_lib/inheritanceClazzContractSuperClassSet/Clazz2|,
		extends(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool methRemWithClass()
	= detection(
		|java+method:///inheritanceClazzContractSuperClassSet/Main/main(java.lang.String%5B%5D)|,
		|java+method:///testing_lib/inheritanceClazzContractSuperClassSet/Clazz2/printClazz2()|,
		|java+method:///testing_lib/inheritanceClazzContractSuperClassSet/Clazz2/printClazz2()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool classRem() 
	= detection(
		|java+method:///inheritanceClazzContractSuperClassSet/Main/main(java.lang.String%5B%5D)|,
		|java+class:///testing_lib/inheritanceClazzContractSuperClassSet/Clazz2|,
		|java+class:///testing_lib/inheritanceClazzContractSuperClassSet/Clazz2|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;