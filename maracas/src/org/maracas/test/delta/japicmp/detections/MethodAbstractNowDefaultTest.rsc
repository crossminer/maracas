module org::maracas::\test::delta::japicmp::detections::MethodAbstractNowDefaultTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool multiInterfaceNoOverride()
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/AbsMethodAbstractNowDefaultMultiInt|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool multiInterfaceOverride()
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool multiInterfaceSubNoOverride()
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/AbsMethodAbstractNowDefaultMultiIntSub|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
		
test bool multiInterfaceSubOverride() 
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiIntSub|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool singleInterfaceNoOverride() 
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/AbsMethodAbstractNowDefaultSingleInt|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool singleInterfaceOverride() 
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultSingleInt|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;