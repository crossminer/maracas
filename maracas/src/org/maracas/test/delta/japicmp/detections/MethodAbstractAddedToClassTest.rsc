module org::maracas::\test::delta::japicmp::detections::MethodAbstractAddedToClassTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


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