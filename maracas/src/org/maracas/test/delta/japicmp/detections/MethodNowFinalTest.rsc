module org::maracas::\test::delta::japicmp::detections::MethodNowFinalTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool override()
	= detection(
		|java+method:///mainclient/methodNowFinal/MethodNowFinalExt/methodNowFinal()|,
		|java+method:///main/methodNowFinal/MethodNowFinal/methodNowFinal()|,
		methodOverride(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool overrideTrans()
	= detection(
		|java+method:///mainclient/methodNowFinal/MethodNowFinalExt/sMethodNowFinal()|,
		|java+method:///main/methodNowFinal/SMethodNowFinal/sMethodNowFinal()|,
		methodOverride(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool simpleAccess()
	= detection(
		|java+method:///mainclient/MethodNowFinalExt/methodNowFinalClient()|,
		|java+method:///main/MethodNowFinal/methodNowFinal()|,
		methodInvocation(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;