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

