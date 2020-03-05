 module org::maracas::\test::delta::japicmp::detections::InterfaceAddedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool interImp()
	= detection(
		|java+class:///mainclient/interfaceAdded/InterfaceAddedImp|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMulti|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMulti|,
		implements(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool interImpMulti()
	= detection(
		|java+class:///mainclient/interfaceAdded/InterfaceAddedImpMulti|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMultiMulti|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMulti|,
		implements(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

// TODO: check if this something we want to keep
test bool interImpMultiSameSrc()
	= detection(
		|java+class:///mainclient/interfaceAdded/InterfaceAddedImpMulti|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMultiMulti|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMultiMulti|,
		implements(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool abstractExt()
	= detection(
		|java+class:///mainclient/interfaceAdded/InterfaceAddedExtAbs|,
		|java+class:///main/interfaceAdded/InterfaceAddedAbs|,
		|java+class:///main/interfaceAdded/InterfaceAddedAbs|,
		extends(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool concreteExt()
	= detection(
		|java+class:///mainclient/interfaceAdded/InterfaceAddedExt|,
		|java+class:///main/interfaceAdded/InterfaceAddedAbs|,
		|java+class:///main/interfaceAdded/InterfaceAddedAbs|,
		extends(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool interImpInter()
	= detection(
		|java+class:///mainclient/interfaceAdded/IInterfaceAddedExt|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMulti|,
		|java+interface:///main/interfaceAdded/IInterfaceAddedMulti|,
		implements(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool abstractExtAbs()
	= detection(
		|java+class:///mainclient/interfaceAdded/AbsInterfaceAddedExtAbs|,
		|java+class:///main/interfaceAdded/InterfaceAddedAbs|,
		|java+class:///main/interfaceAdded/InterfaceAddedAbs|,
		extends(),
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;