module org::maracas::\test::delta::japicmp::detections::MethodRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool simpleAccess()
	= detection(
		|java+method:///mainclient/methodRemoved/MethodRemovedMI/methodRemovedClient()|,
    	|java+method:///main/methodRemoved/MethodRemoved/methodRemoved()|,
    	methodInvocation(),
    	methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/methodRemoved/MethodRemovedExt/methodRemovedClientSuper()|,
		|java+method:///main/methodRemoved/MethodRemoved/methodRemoved()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/methodRemoved/MethodRemovedExt/methodRemovedClientExt()|,
		|java+method:///main/methodRemoved/MethodRemoved/methodRemoved()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
// TODO: Removed interface methods are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// methodOverrides relation).
test bool methodOverrides()
	= detection(
		|java+method:///mainclient/methodRemoved/MethodRemovedImp/methodRemoved()|,
		|java+method:///main/methodRemoved/IMethodRemoved/methodRemoved()|,
		methodOverride(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;