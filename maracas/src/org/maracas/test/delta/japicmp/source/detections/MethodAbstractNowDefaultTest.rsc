module org::maracas::\test::delta::japicmp::source::detections::MethodAbstractNowDefaultTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool multiInterfaceNoOverride()
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/AbsMethodAbstractNowDefaultMultiInt|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefault|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool multiInterfaceOverride()
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiInt|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefault|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool multiInterfaceSubNoOverride()
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/AbsMethodAbstractNowDefaultMultiIntSub|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefaultSub|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
		
test bool multiInterfaceSubOverride() 
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultMultiIntSub|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefaultSub|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool singleInterfaceNoOverride() 
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/AbsMethodAbstractNowDefaultSingleInt|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefault|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool singleInterfaceOverride() 
	= detection(
		|java+class:///mainclient/methodAbstractNowDefault/MethodAbstractNowDefaultSingleInt|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefault|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool multiInterfaceAbsOwnDef()
	= detection(
		|java+class:///mainclient/methodNewDefault/AbsMethodAbstractNowDefaultMultiIntOwnDef|,
		|java+interface:///main/methodAbstractNowDefault/IMethodAbstractNowDefault|,
		|java+method:///main/methodAbstractNowDefault/IMethodAbstractNowDefault/methodAbstractNowDef()|,
		implements(),
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;