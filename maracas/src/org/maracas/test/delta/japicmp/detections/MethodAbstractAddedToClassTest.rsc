module org::maracas::\test::delta::japicmp::detections::MethodAbstractAddedToClassTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool abstractMeth()
	= detection(
		|java+class:///mainclient/methodAbstractAddedToClass/MethodAbstractAddedToClassExt|,
		|java+method:///main/methodAbstractAddedToClass/MethodAbstractAddedToClass/abstractNew()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool concreteMeth()
	= detection(
		|java+class:///mainclient/methodAbstractAddedToClass/MethodAbstractAddedToClassExt|,
		|java+method:///main/methodAbstractAddedToClass/MethodAbstractAddedToClass/concreteNew()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;

test bool abstractSubtype()
	= detection(
		|java+class:///mainclient/methodAbstractAddedToClass/AbsMethodAbstractAddedToClassExt|,
		|java+method:///main/methodAbstractAddedToClass/MethodAbstractAddedToClass/abstractNew()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;

test bool concreteSubtype()
	= detection(
		|java+class:///mainclient/methodAbstractAddedToClass/ConcMethodAbstractAddedToClassExt|,
		|java+method:///main/methodAbstractAddedToClass/MethodAbstractAddedToClass/abstractNew()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool subtypeAbstractMeth()
	= detection(
		|java+class:///mainclient/methodAbstractAddedToClass/MethodAbstractAddedToClassSubExt|,
		|java+method:///main/methodAbstractAddedToClass/MethodAbstractAddedToClass/abstractNew()|,
		extends(),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	in detects;