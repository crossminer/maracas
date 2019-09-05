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
// Field no longer static tests
//----------------------------------------------

public test bool fieldNoLongerStaticSimpleAccess() 
	= detection(
		|java+method:///mainclient/FieldNoLongerStaticFA/fieldNoLongerStaticClient()|,
		|java+field:///main/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: the super keyword refers to the parent class OBJECT.
// Even though it is a bad practice to access class fields 
// through objects it is not a problem when the we refer to 
// an instance field. 
public test bool fieldNoLongerStaticSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldNoLongerStaticExt/fieldNoLongerStaticClientSuperKey()|,
		|java+field:///main/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool fieldNoLongerStaticNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldNoLongerStaticExt/fieldNoLongerStaticClientNoSuperKey()|,
		|java+field:///main/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
    
//----------------------------------------------
// Field now final tests
//----------------------------------------------

public test bool fieldNowFinalSimpleAccessAssign() 
	= detection(
		|java+method:///mainclient/FieldNowFinalFA/fieldNowFinalAssignment()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool fieldNowFinalSimpleAccessNoAssign()
	= detection(
		|java+method:///mainclient/FieldNowFinalFA/fieldNowFinalNoAssignment()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldNowStaticSuperKeyAccessAssign()
	= detection(
		|java+method:///mainclient/FieldNowFinalExt/fieldNowFinalAssignmentSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool fieldNowStaticSuperKeyAccessNoAssign()
	= detection(
		|java+method:///mainclient/FieldNowFinalExt/fieldNowFinalNoAssignmentSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldNowStaticNoSuperKeyAccessAssign()
	= detection(
		|java+method:///mainclient/FieldNowFinalExt/fieldNowFinalAssignmentNoSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool fieldNowStaticNoSuperKeyAccessNoAssign()
	= detection(
		|java+method:///mainclient/FieldNowFinalExt/fieldNowFinalNoAssignmentNoSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
    
  
//----------------------------------------------
// Field now static tests
//----------------------------------------------

public test bool fieldNowStaticSimpleAccess()
	= detection(
		|java+method:///mainclient/FieldNowStaticFA/fieldNowStaticClientSimpleAccess()|,
		|java+field:///main/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool fieldNowStaticSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldNowStaticExt/fieldNowStaticClientSuperKeyAccess()|,
		|java+field:///main/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldNowStaticNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldNowStaticExt/fieldNowStaticClientNoSuperKeyAccess()|,
		|java+field:///main/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;    
	
	
//----------------------------------------------
// Field removed tests
//----------------------------------------------

public test bool removedFieldSimpleAccess()
	= detection(
		|java+method:///mainclient/FieldRemovedFA/fieldRemovedClient()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool removedFieldSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldRemovedExt/fieldRemovedClientSuper()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool removedFieldNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldRemovedExt/fieldRemovedClientExt()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: Removed interface fields (constants) are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check fieldAccesss
// relation).
public test bool removedFieldInterface1()
	= detection(
		|java+method:///mainclient/FieldRemovedImp/fieldRemovedClient()|,
		|java+field:///main/IFieldRemoved/FIELD_REMOVED|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// fieldAccesss relation).
public test bool removedFieldInterface1()
	= detection(
		|java+method:///mainclient/FieldRemovedImp/fieldRemovedClientType()|,
		|java+field:///main/IFieldRemoved/FIELD_REMOVED|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;


//----------------------------------------------
// Field type changed tests
//----------------------------------------------

public test bool filedTypeChangedNumericSimpleAccess()
	= detection(
		|java+method:///mainclient/FieldTypeChangedFA/fieldTypeChangedClient()|,
		|java+field:///main/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool filedTypeChangedListSimpleAccess()
	= detection(
		|java+method:///mainclient/FieldTypeChangedFA/fieldTypeChangedClient()|,
		|java+field:///main/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool filedTypeChangedNumericSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldTypeChangedExt/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool filedTypeChangedListSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldTypeChangedExt/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API 
// field without the super keyword, javac registers the field as a 
// field within the client class 
public test bool filedTypeChangedNumericNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldTypeChangedExt/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool filedTypeChangedListNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/FieldTypeChangedExt/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	

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


//----------------------------------------------
// Method no longer static tests
//----------------------------------------------

// TODO: the access is done through an object.
public test bool methodNoLongerStaticSimpleAccessObj()
	= detection(
		|java+method:///mainclient/MethodNoLongerStaticMI/methodNoLongerStaticClientObject()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodNoLongerStaticSimpleAccessClass()
	= detection(
		|java+method:///mainclient/MethodNoLongerStaticMI/methodNoLongerStaticClientClass()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: the super keyword refers to the parent class OBJECT.
// Even though it is a bad practice to access class methods 
// through objects it is not a problem when we refer to an
// instance method. 
public test bool methodNoLongerStaticSuperKeyAccess()
	= detection(
		|java+method:///mainclient/MethodNoLongerStaticExt/methodNoLongerStaticSuperKeyAccess()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: we are referring to the parent class object (assuming
// that the method cannot be overriden).
public test bool methodNoLongerStaticNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/MethodNoLongerStaticExt/methodNoLongerStaticNoSuperKeyAccess()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodNoLongerStaticImpl()
	= detection(
		|java+method:///mainclient/MethodNoLongerStaticImp/methodNoLongerStaticClient()|,
		|java+method:///main/IMethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	

//----------------------------------------------
// Method now abstract tests
//----------------------------------------------

public test bool methodNowAbstractNoOverrideExt()
	= detection(
		|java+class:///mainclient/MethodNowAbstractExt|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodNowAbstractNoOverrideExtWithImpl()
	= detection(
		|java+class:///mainclient/MethodNowAbstractExtWithImpl|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
public test bool methodNowAbstractNoOverrideImpl()
	= detection(
		|java+class:///mainclient/MethodNowAbstractImp|,
		|java+method:///main/IMethodNowAbastract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodNowAbstractSuperInvExt()
	= detection(
		|java+method:///mainclient/MethodNowAbstractExt/methodNowAbstractClientSuperKey()|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodNowAbstractNoSuperInvExt()
	= detection(
		|java+method:///mainclient/MethodNowAbstractExt/methodNowAbstractClientNoSuperKey()|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodNowAbstractSuperInvImpl()
	= detection(
		|java+method:///mainclient/MethodNowAbstractImp/methodNowAbstractClient()|,
		|java+method:///main/IMethodNowAbastract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool methodNowAbstractNoOverrideAbstractSubtype()
	= detection(
		|java+class:///mainclient/MethodNowAbstractAbstractSubtype|,
		|java+method:///main/IMethodNowAbastract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
	
    
//----------------------------------------------
// Method now final tests
//----------------------------------------------

// TODO: This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// methodOverrides relation).
public test bool methodNowFinalOverride()
	= detection(
		|java+method:///mainclient/MethodNowFinalExt/methodNowFinal()|,
		|java+method:///main/MethodNowFinal/methodNowFinal()|,
		methodOverride(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool methodNowFinalSimpleAccess()
	= detection(
		|java+method:///mainclient/MethodNowFinalExt/methodNowFinalClient()|,
		|java+method:///main/MethodNowFinal/methodNowFinal()|,
		methodInvocation(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

	
//----------------------------------------------
// Method now static tests
//----------------------------------------------

public test bool methodNowStaticSimpleAccess()
	= detection(
		|java+method:///mainclient/MethodNowStaticMI/methodNowStaticClient()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
	    
public test bool methodNowStaticSuperKeyAccess()
	= detection(
		|java+method:///mainclient/MethodNowStaticExt/methodNowStaticClientSuperKeyAccess()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodNowStaticNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/MethodNowStaticExt/methodNowStaticClientNoSuperKeyAccess()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Modified interface methods are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// methodOverrides relation).
public test bool methodNowStaticOverride()
	= detection(
		|java+method:///mainclient/MethodNowStaticExtOverriden/methodNowStatic()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodOverride(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodNowStaticInterface()
	= detection(
		|java+method:///mainclient/MethodNowStaticImp/methodNowStaticClient()|,
		|java+method:///main/IMethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects; 

    
//----------------------------------------------
// Method removed tests
//----------------------------------------------

public test bool removedMethodSimpleAccess()
	= detection(
		|java+method:///mainclient/MethodRemovedMI/methodRemovedClient()|,
    	|java+method:///main/MethodRemoved/methodRemoved()|,
    	methodInvocation(),
    	methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool removedMethodSuperKeyAccess()
	= detection(
		|java+method:///mainclient/MethodRemovedExt/methodRemovedClientSuper()|,
		|java+method:///main/MethodRemoved/methodRemoved()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool removedFieldNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/MethodRemovedExt/methodRemovedClientExt()|,
		|java+method:///main/MethodRemoved/methodRemoved()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
// TODO: Removed interface methods are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// methodOverrides relation).
public test bool removedFieldMethodOverrides()
	= detection(
		|java+method:///mainclient/MethodRemovedImp/methodRemoved()|,
		|java+method:///main/IMethodRemoved/methodRemoved()|,
		methodOverride(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    

//----------------------------------------------
// Method return type tests
//----------------------------------------------

// TODO: If the method type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool methodReturnTypeSimpleAccessNumeric()
	= detection(
		|java+method:///mainclient/MethodReturnTypeChangedMI/methodReturnTypeChangedNumericClient()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodReturnTypeSimpleAccessList()
    = detection(
    	|java+method:///mainclient/MethodReturnTypeChangedMI/methodReturnTypeChangedListClient()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: If the method type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool methodReturnTypeSuperKeyNumeric()
    = detection(
    	|java+method:///mainclient/MethodReturnTypeChangedExt/methodReturnTypeChangedNumericClientSuperKey()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

public test bool methodReturnTypeSuperKeyNumeric()
	= detection(
		|java+method:///mainclient/MethodReturnTypeChangedExt/methodReturnTypeChangedListClientSuperKey()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API 
// method without the super keyword, javac registers the method as a 
// method within the client class 
public test bool methodReturnTypeNoSuperKeyNumeric()
    = detection(
    	|java+method:///mainclient/MethodReturnTypeChangedExt/methodReturnTypeChangedNumericClientNoSuperKey()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

// TODO: If the client class extends an API class and accesses the API 
// method without the super keyword, javac registers the method as a 
// method within the client class 
public test bool methodReturnTypeNoSuperKeyNumeric()
	= detection(
		|java+method:///mainclient/MethodReturnTypeChangedExt/methodReturnTypeChangedListClientNoSuperKey()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: problem with the methodOverride relation.
public test bool methodReturnTypeOverrideNumeric()
	= detection(
		|java+method:///mainclient/MethodReturnTypeChangedImp/methodReturnTypeChangedNumeric()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
		methodOverride(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: problem with the methodOverride relation.
public test bool methodReturnTypeOverrideList()
    = detection(
    	|java+method:///mainclient/MethodReturnTypeChangedImp/methodReturnTypeChangedNumeric()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
    	methodOverride(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    

//----------------------------------------------
// Constructor less accessible tests
//----------------------------------------------

public test bool constructorLessAccessibleSimpleAccessPub2Pro()
	= detection(
		|java+method:///mainclient/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool constructorLessAccessibleSimpleAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool constructorLessAccessibleSimpleAccessPub2Priv()
	= detection(
		|java+method:///mainclient/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool constructorLessAccessibleSuperAccessPub2Pro()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Pro/ConstructorLessAccessibleExtPub2Pro()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
  		
public test bool constructorLessAccessibleSuperAccessPub2PackPriv()	
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2PackPriv/ConstructorLessAccessibleExtPub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool constructorLessAccessibleSuperAccessPub2Priv()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Priv/ConstructorLessAccessibleExtPub2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool constructorLessAccessibleSuperAccessPro2PackPriv()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2PackPriv/ConstructorLessAccessibleExtPro2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool constructorLessAccessibleSuperAccessPro2Priv()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2Priv/ConstructorLessAccessibleExtPro2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2Priv/ConstructorLessAccessiblePro2Priv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool constructorLessAccessibleSuperAccessPub2ProParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Pro/ConstructorLessAccessibleExtPub2Pro(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool constructorLessAccessibleSuperAccessPub2PackPrivParams()	
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2PackPriv/ConstructorLessAccessibleExtPub2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool constructorLessAccessibleSuperAccessPub2PrivParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Priv/ConstructorLessAccessibleExtPub2Priv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool constructorLessAccessibleSuperAccessPro2PackPrivParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2PackPriv/ConstructorLessAccessibleExtPro2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool constructorLessAccessibleSuperAccessPro2PrivParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2Priv/ConstructorLessAccessibleExtPro2Priv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2Priv/ConstructorLessAccessiblePro2Priv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
