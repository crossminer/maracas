module org::maracas::\test::delta::japicmp::detections::MethodNewDefaultTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;

test bool multiInterfaceNoOverride()
	= detection(
		|java+class:///mainclient/methodNewDefault/AbsMethodNewDefaultMultiInt|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool multiInterfaceOverride()
	= detection(
		|java+class:///mainclient/methodNewDefault/MethodNewDefaultMultiInt|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool multiInterfaceSubNoOverride()
	= detection(
		|java+class:///mainclient/methodNewDefault/AbsMethodNewDefaultMultiIntSub|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool multiInterfaceSubOverride() 
	= detection(
		|java+class:///mainclient/methodNewDefault/MethodNewDefaultMultiIntSub|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool singleInterfaceNoOverride() 
	= detection(
		|java+class:///mainclient/methodNewDefault/AbsMethodNewDefaultSingleInt|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool singleInterfaceOverride() 
	= detection(
		|java+class:///mainclient/methodNewDefault/MethodNewDefaultSingleInt|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool multiInterfaceAbsOwnDef()
	= detection(
		|java+class:///mainclient/methodNewDefault/AbsMethodNewDefaultMultiIntOwnDef|,
		|java+method:///main/methodNewDefault/IMethodNewDefault/defaultMethod()|,
		implements(),
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;