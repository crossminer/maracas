module org::maracas::\test::delta::japicmp::detections::SuperclassAddedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool extendAbs()
	= detection(
		|java+class:///mainclient/superclassAdded/SuperclassAddedExtAbs|,
		|java+class:///main/superclassAdded/SuperclassAddedAbs|,
		extends(),
		superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool extendsAbsMulti()
	= detection(
		|java+class:///mainclient/superclassAdded/SuperclassAddedImp|,
		|java+class:///main/superclassAdded/SuperSuperclassAddedMulti|,
		extends(),
		superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool extendsAbsMultiMulti()
	= detection(
		|java+class:///mainclient/superclassAdded/SuperclassAddedImpMulti|,
		|java+class:///main/superclassAdded/SuperSuperclassAddedMultiMulti|,
		extends(),
		superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool concreteExt()
	= detection(
		|java+class:///mainclient/superclassAdded/SuperclassAddedExt|,
		|java+class:///main/superclassAdded/SuperclassAddedAbs|,
		extends(),
		superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool abstractExtAbs1()
	= detection(
		|java+class:///mainclient/superclassAdded/SuperSuperclassAddedExt|,
		|java+interface:///main/superclassAdded/SuperSuperclassAddedMulti|,
		implements(),
		superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool abstractExtAbs2()
	= detection(
		|java+class:///mainclient/superclassAdded/AbsSuperclassAddedExtAbs|,
		|java+class:///main/superclassAdded/SuperclassAddedAbs|,
		extends(),
		superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;