module org::maracas::\test::delta::japicmp::detections::MethodNoLongerStaticTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


// TODO: the access is done through an object.
public test bool simpleAccessObj()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticMI/methodNoLongerStaticClientObject()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool simpleAccessClass()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticMI/methodNoLongerStaticClientClass()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: the super keyword refers to the parent class OBJECT.
// Even though it is a bad practice to access class methods 
// through objects it is not a problem when we refer to an
// instance method. 
public test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticExt/methodNoLongerStaticSuperKeyAccess()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticExt/methodNoLongerStaticNoSuperKeyAccess()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool interface()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticImp/methodNoLongerStaticClient()|,
		|java+method:///main/methodNoLongerStatic/IMethodNoLongerStatic/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/IMethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool hideNonStaticAsStatic()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticHideExt/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodOverride(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool hideStaticAsStatic()
	= detection(
		|java+method:///mainclient/methodNoLongerStatic/MethodNoLongerStaticHideExt/methodRemainsStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodRemainsStatic()|,
		|java+method:///main/methodNoLongerStatic/MethodNoLongerStatic/methodRemainsStatic()|,
		methodOverride(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;