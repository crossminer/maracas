module org::maracas::\test::delta::japicmp::source::detections::MethodAbstractAddedInSuperclassTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool methAddedToSSItself()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtSS|,
		|java+class:///main/methodAbstractAddedInSuperclass/SSMethodAbstractAddedInSuperclass|,
		|java+method:///main/methodAbstractAddedInSuperclass/SSMethodAbstractAddedInSuperclass/methodsSS()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool methAddedToSConcSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtS|,
		|java+class:///main/methodAbstractAddedInSuperclass/SMethodAbstractAddedInSuperclass|,
		|java+method:///main/methodAbstractAddedInSuperclass/SMethodAbstractAddedInSuperclass/methodsS()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
    in detects;

test bool methAddedToSSConcSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtS|,
		|java+class:///main/methodAbstractAddedInSuperclass/SMethodAbstractAddedInSuperclass|,
		|java+method:///main/methodAbstractAddedInSuperclass/SSMethodAbstractAddedInSuperclass/methodsSS()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool methAddedToSAbsSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtAbs|,
		|java+class:///main/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassAbs|,
		|java+method:///main/methodAbstractAddedInSuperclass/SMethodAbstractAddedInSuperclass/methodsS()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
    
test bool methAddedToSSAbsSub()
	= detection(
		|java+class:///mainclient/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassExtAbs|,
		|java+class:///main/methodAbstractAddedInSuperclass/MethodAbstractAddedInSuperclassAbs|,
		|java+method:///main/methodAbstractAddedInSuperclass/SSMethodAbstractAddedInSuperclass/methodsSS()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;