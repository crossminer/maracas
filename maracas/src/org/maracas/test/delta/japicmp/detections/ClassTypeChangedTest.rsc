module org::maracas::\test::delta::japicmp::detections::ClassTypeChangedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;

test bool c2iExt()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedC2IExt|,
		|java+class:///main/classTypeChanged/ClassTypeChangedC2I|,
		extends(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool c2eExt()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedC2EExt|,
		|java+class:///main/classTypeChanged/ClassTypeChangedC2E|,
		extends(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool c2aExt()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedC2AExt|,
		|java+class:///main/classTypeChanged/ClassTypeChangedC2A|,
		extends(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool i2cExt()
	= detection(
		|java+interface:///mainclient/classTypeChanged/ClassTypeChangedI2CExt|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedI2C|,
		extends(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool i2eExt()
	= detection(
		|java+interface:///mainclient/classTypeChanged/ClassTypeChangedI2EExt|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedI2E|,
		extends(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool i2aExt()
	= detection(
		|java+interface:///mainclient/classTypeChanged/ClassTypeChangedI2AExt|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedI2A|,
		extends(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool i2cImp()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedI2CImp|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedI2C|,
		implements(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool i2eImp()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedI2EImp|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedI2E|,
		implements(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool i2aImp()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedI2AImp|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedI2A|,
		implements(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

//test bool e2iFieldTD();
//test bool e2cFieldTD();
//test bool e2aFieldTD();
//
//test bool e2iVarTD();
//test bool e2cVarTD();
//test bool e2aVarTD();

test bool a2cAnnMethod()
	= detection(
		|java+method:///mainclient/classTypeChanged/ClassTypeChangedA2CAnn/a2cAnn()|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedA2C|,
		annotation(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool a2iAnnMethod()
	= detection(
		|java+method:///mainclient/classTypeChanged/ClassTypeChangedA2IAnn/a2iAnn()|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedA2I|,
		annotation(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool a2eAnnMethod()
	= detection(
		|java+method:///mainclient/classTypeChanged/ClassTypeChangedA2EAnn/a2eAnn()|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedA2E|,
		annotation(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool a2eAnnClass()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedA2EAnn|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedA2E|,
		annotation(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool a2iAnnClass()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedA2IAnn|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedA2I|,
		annotation(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool a2cAnnClass()
	= detection(
		|java+class:///mainclient/classTypeChanged/ClassTypeChangedA2CAnn|,
		|java+interface:///main/classTypeChanged/ClassTypeChangedA2C|,
		annotation(),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;