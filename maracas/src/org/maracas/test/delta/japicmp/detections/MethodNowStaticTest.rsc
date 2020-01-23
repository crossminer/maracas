module org::maracas::\test::delta::japicmp::detections::MethodNowStaticTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool simpleAccess()
	= detection(
		|java+method:///mainclient/methodNowStatic/MethodNowStaticMI/methodNowStaticClient()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
	    
test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/methodNowStatic/MethodNowStaticExt/methodNowStaticClientSuperKeyAccess()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/methodNowStatic/MethodNowStaticExt/methodNowStaticClientNoSuperKeyAccess()|,
		|java+method:///mainclient/methodNowStatic/MethodNowStaticExt/methodNowStatic()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool override()
	= detection(
		|java+method:///mainclient/methodNowStatic/MethodNowStaticExtOverriden/methodNowStatic()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		|java+method:///main/methodNowStatic/MethodNowStatic/methodNowStatic()|,
		methodOverride(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool interface()
	= detection(
		|java+method:///mainclient/methodNowStatic/MethodNowStaticImp/methodNowStaticClient()|,
		|java+method:///mainclient/methodNowStatic/MethodNowStaticImp/methodNowStatic()|,
		|java+method:///main/methodNowStatic/IMethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects; 