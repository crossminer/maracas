module org::maracas::\test::delta::japicmp::detections::MethodLessAccessibleTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool simpleAccessPub2Pro()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMI/methodLessAccessiblePub2ProClientSimpleAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool simpleAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMI/methodLessAccessiblePub2PackPrivClientSimpleAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool simpleAccessPub2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMI/methodLessAccessiblePub2PrivClientSimpleAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePub2ProClientSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool superKeyAccessPub2PackPriv()	
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PrivClientSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PrivClientSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
test bool noSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool noSuperKeyAccessPub2PackPriv()	
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool noSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PrivClientNoSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool noSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool noSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PrivClientNoSuperKeyAccess()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overridePub2Pro()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessiblePublic2Protected()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
 
test bool overridePub2PackPriv()	
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessiblePublic2PackPriv()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	 
test bool overridePub2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessiblePublic2Private()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overridePro2PackPriv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessibleProtected2PackPriv()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overridePro2Priv()
	= detection(
		|java+method:///mainclient/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessibleProtected2Private()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;	

test bool simpleAccessPub2PackPrivSamePack()
	= detection(
		|java+method:///main/methodLessAccessible/MethodLessAccessibleMI/clientPublic()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool simpleAccessPro2PackPrivSamePack()
	= detection(
		|java+method:///main/methodLessAccessible/MethodLessAccessibleMI/clientProtected()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool overridePub2PackPrivSamePack()	
	= detection(
		|java+method:///main/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessiblePublic2PackPriv()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool overridePro2PackPrivSamePack()
	= detection(
		|java+method:///main/methodLessAccessible/MethodLessAccessibleExt/methodLessAccessibleProtected2PackPriv()|,
		|java+method:///main/methodLessAccessible/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;