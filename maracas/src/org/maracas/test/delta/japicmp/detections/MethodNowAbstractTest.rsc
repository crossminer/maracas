module org::maracas::\test::delta::japicmp::detections::MethodNowAbstractTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool noOverrideExt()
	= detection(
		|java+class:///mainclient/methodNowAbstract/MethodNowAbstractExt|,
		|java+method:///main/methodNowAbstract/MethodNowAbstract/methodNowAbstract()|,
		extends(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noOverrideExtWithImpl()
	= detection(
		|java+class:///mainclient/methodNowAbstract/MethodNowAbstractExtWithImpl|,
		|java+method:///main/methodNowAbstract/MethodNowAbstract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
public test bool noOverrideImpl()
	= detection(
		|java+class:///mainclient/methodNowAbstract/MethodNowAbstractImp|,
		|java+method:///main/methodNowAbstract/IMethodNowAbastract/methodNowAbstract()|,
		implements(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool superInvExt()
	= detection(
		|java+method:///mainclient/methodNowAbstract/MethodNowAbstractExt/methodNowAbstractClientSuperKey()|,
		|java+method:///main/methodNowAbstract/MethodNowAbstract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperInvExt()
	= detection(
		|java+method:///mainclient/methodNowAbstract/MethodNowAbstractExt/methodNowAbstractClientNoSuperKey()|,
		|java+method:///main/methodNowAbstract/MethodNowAbstract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool superInvImpl()
	= detection(
		|java+method:///mainclient/methodNowAbstract/MethodNowAbstractImp/methodNowAbstractClient()|,
		|java+method:///main/methodNowAbstract/IMethodNowAbastract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool noOverrideAbstractSubtype()
	= detection(
		|java+class:///mainclient/methodNowAbstract/MethodNowAbstractAbstractSubtype|,
		|java+method:///main/methodNowAbstract/IMethodNowAbastract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;