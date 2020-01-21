module org::maracas::\test::delta::japicmp::detections::MethodReturnTypeChangedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


// TODO: If the method type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool simpleAccessNumeric()
	= detection(
		|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedMI/numericClient()|,
		|java+method:///main/methodReturnTypeChanged/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool simpleAccessList()
    = detection(
    	|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedMI/listClient()|,
    	|java+method:///main/methodReturnTypeChanged/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: If the method type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool superKeyNumeric()
    = detection(
    	|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedExt/numericClientSuperKey()|,
    	|java+method:///main/methodReturnTypeChanged/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

test bool superKeyList()
	= detection(
		|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedExt/listClientSuperKey()|,
		|java+method:///main/methodReturnTypeChanged/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the method type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool noSuperKeyNumeric()
    = detection(
    	|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedExt/numericClientNoSuperKey()|,
    	|java+method:///main/methodReturnTypeChanged/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

test bool noSuperKeyList()
	= detection(
		|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedExt/listClientNoSuperKey()|,
		|java+method:///main/methodReturnTypeChanged/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overrideNumeric()
	= detection(
		|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedImp/methodReturnTypeChangedNumeric()|,
		|java+method:///main/methodReturnTypeChanged/IMethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
		methodOverride(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overrideList()
    = detection(
    	|java+method:///mainclient/methodReturnTypeChanged/MethodReturnTypeChangedImp/methodReturnTypeChangedList()|,
    	|java+method:///main/methodReturnTypeChanged/IMethodReturnTypeChanged/methodReturnTypeChangedList()|,
    	methodOverride(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;