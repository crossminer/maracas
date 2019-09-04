module org::maracas::\test::delta::japicmp::detections::MethodAbstractAddedInSuperclassTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


test bool methAddedToSSItself()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtSS|,
		|java+class:///main/methodAbstractAddedInSuperclass/SSMethodAbstractAddedInSuperclass|,
		extends(),
		methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool methAddedToSSAbsSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtS|,
		|java+class:///main/methodAbstractAddedInSuperclass/SMethodAbstractAddedInSuperclass|,
		extends(),
		methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool methAddedToSAbsSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtAbs|,
		|java+class:///main/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassAbs|,
		extends(),
		methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool methAddedToSNonAbsSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExt|,
		|java+class:///main/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclass|,
		extends(),
		methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;