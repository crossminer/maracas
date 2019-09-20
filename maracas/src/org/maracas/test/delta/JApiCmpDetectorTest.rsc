module org::maracas::\test::delta::JApiCmpDetectorTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

loc apiOld = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-old.jar|;
loc apiNew = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-new.jar|;
loc client = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-client.jar|;

M3 m3ApiOld = createM3FromJar(apiOld);
M3 m3ApiNew = createM3FromJar(apiOld);
public M3 m3Client = createM3FromJar(client);

public list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
public set[Detection] detects = detections(m3Client, m3ApiOld, m3ApiNew, delta);


//----------------------------------------------
// Field less accessible tests
//----------------------------------------------

public test bool fieldLessAccessibleSimpleAccessPub2Pro()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFA/fieldLessAccessibleClientPub2Pro()|,
		|java+field:///main/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSimpleAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFA/fieldLessAccessibleClientPub2PackPriv()|,
		|java+field:///main/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSimpleAccessPub2Priv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFA/fieldLessAccessibleClientPub2Priv()|,
		|java+field:///main/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2ProSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool fieldLessAccessibleSuperKeyAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PackPrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
public test bool fieldLessAccessibleSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PackPrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool fieldLessAccessibleSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2ProNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PackPrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class. 
public test bool fieldLessAccessibleNoSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PackPrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	

//----------------------------------------------
// Method less accessible tests
//----------------------------------------------

public test bool methodLessAccessibleSimpleAccessPub2Pro()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMI/methodLessAccessiblePub2ProClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodLessAccessibleSimpleAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMI/methodLessAccessiblePub2PackPrivClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool methodLessAccessibleSimpleAccessPub2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMI/methodLessAccessiblePub2PrivClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool methodLessAccessibleSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodLessAccessibleSuperKeyAccessPub2PackPriv()	
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool methodLessAccessibleSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodLessAccessibleSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodLessAccessibleSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodLessAccessibleNoSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodLessAccessibleNoSuperKeyAccessPub2PackPriv()	
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodLessAccessibleNoSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodLessAccessibleNoSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodLessAccessibleNoSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodLessAccessibleOverridePub2Pro()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePublic2Protected()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodLessAccessibleOverridePub2PackPriv()	
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePublic2PackPriv()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodLessAccessibleOverridePub2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessiblePublic2Private()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodLessAccessibleOverridePro2PackPriv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessibleProtected2PackPriv()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodLessAccessibleOverridePro2Priv()
	= detection(
		|java+method:///mainclient/MethodLessAccessibleMISubtype/methodLessAccessibleProtected2Private()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;	

