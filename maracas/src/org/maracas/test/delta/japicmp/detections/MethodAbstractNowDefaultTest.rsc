module org::maracas::\test::delta::japicmp::detections::MethodAbstractNowDefaultTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


test bool multiInterfaceOverride()
	= detection(
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt/methodAbstractNowDef()|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		methodOverride(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool otherIntWithSameDefault() 
	= detection(
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt/callMethod()|,
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt/methodAbstractNowDef()|,
		methodInvocation(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool otherIntWithSameDefaultSuper() 
	= detection(
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt/callMethodOther()|,
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt/methodAbstractNowDef()|,
		methodInvocation(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool singleInterfaceOverride() 
	= detection(
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultSingleInt/methodAbstractNowDef()|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		methodOverride(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool singleInterfaceMI() 
	= detection(
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultSingleInt/callMethod()|,
		|java+method:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultSingleInt/methodAbstractNowDef()|,
		methodInvocation(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	