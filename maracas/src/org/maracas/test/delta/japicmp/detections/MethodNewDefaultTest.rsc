module org::maracas::\test::delta::japicmp::detections::MethodNewDefaultTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;
import util::ValueUI;

test bool otherIntWithSameDefault() 
	= detection(
		|java+method:///mainclient/methodNewDefault/MethodNewDefaultMultiInt/callDefaultMethodOther()|,
		|java+method:///main/methodNewDefault/IMethodNewDefaultOther/defaultMethod()|,
		methodInvocation(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool otherIntWithSameDefaultSuper() 
	= detection(
		|java+method:///mainclient/methodNewDefault/MethodNewDefaultMultiInt/callDefaultMethodOtherSuper()|,
		|java+method:///main/methodNewDefault/IMethodNewDefaultOther/defaultMethod()|,
		methodInvocation(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool singleInterface() 
	= detection(
		|java+method:///mainclient/methodNewDefault/MethodNewDefaultMultiInt/callingNothing()|,
		|java+method:///main/methodNewDefault/IMethodNewDefaultOther/defaultMethod()|,
		methodInvocation(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool ownDefinition() 
	= detection(
		|java+method:///mainclient/methodNewDefault/MethodNewDefaultOwnDef/callOwnDefaultMethod()|,
		|java+method:///main/methodNewDefault/IMethodNewDefaultOther/defaultMethod()|,
		methodInvocation(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	