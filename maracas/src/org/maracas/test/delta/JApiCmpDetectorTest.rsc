module org::maracas::\test::delta::JApiCmpDetectorTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

loc apiOld = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-old.jar|;
loc apiNew = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-new.jar|;
loc client = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-client.jar|;

M3 m3ApiOld = createM3FromJar(apiOld);
public M3 m3Client = createM3FromJar(client);

public list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
public set[Detection] detects = detections(m3Client, m3ApiOld, delta);


//----------------------------------------------
// Field less accessible tests
//----------------------------------------------

public test bool fieldLessAccessibleSimpleAccessPub2Pro()
	= detection(
		|java+method:///main/FieldLessAccessibleFA/fieldLessAccessibleClientPub2Pro()|,
		|java+field:///main/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSimpleAccessPub2PackPriv()
	= detection(
		|java+method:///main/FieldLessAccessibleFA/fieldLessAccessibleClientPub2PackPriv()|,
		|java+field:///main/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSimpleAccessPub2Priv()
	= detection(
		|java+method:///main/FieldLessAccessibleFA/fieldLessAccessibleClientPub2Priv()|,
		|java+field:///main/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2ProSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool fieldLessAccessibleSuperKeyAccessPub2PackPriv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PackPrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
public test bool fieldLessAccessibleSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PackPrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool fieldLessAccessibleSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PrivSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2ProNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2PackPriv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PackPrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class. 
public test bool fieldLessAccessibleNoSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PackPrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///main/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PrivNoSuperKey()|,
		|java+field:///main/FieldLessAccessible/protected2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	

//----------------------------------------------
// Field no longer static tests
//----------------------------------------------

public test bool fieldNoLongerStaticSimpleAccess() 
	= detection(
		|java+method:///main/FieldNoLongerStaticFA/fieldNoLongerStaticClient()|,
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
		|java+method:///main/FieldNoLongerStaticExt/fieldNoLongerStaticClientSuperKey()|,
		|java+field:///main/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool fieldNoLongerStaticNoSuperKeyAccess()
	= detection(
		|java+method:///main/FieldNoLongerStaticExt/fieldNoLongerStaticClientNoSuperKey()|,
		|java+field:///main/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
    
//----------------------------------------------
// Field now final tests
//----------------------------------------------

public test bool fieldNowFinalSimpleAccessAssign() 
	= detection(
		|java+method:///main/FieldNowFinalFA/fieldNowFinalAssignment()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool fieldNowFinalSimpleAccessNoAssign()
	= detection(
		|java+method:///main/FieldNowFinalFA/fieldNowFinalNoAssignment()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldNowStaticSuperKeyAccessAssign()
	= detection(
		|java+method:///main/FieldNowFinalExt/fieldNowFinalAssignmentSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool fieldNowStaticSuperKeyAccessNoAssign()
	= detection(
		|java+method:///main/FieldNowFinalExt/fieldNowFinalNoAssignmentSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldNowStaticNoSuperKeyAccessAssign()
	= detection(
		|java+method:///main/FieldNowFinalExt/fieldNowFinalAssignmentNoSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool fieldNowStaticNoSuperKeyAccessNoAssign()
	= detection(
		|java+method:///main/FieldNowFinalExt/fieldNowFinalNoAssignmentNoSuperKey()|,
		|java+field:///main/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
    
  
//----------------------------------------------
// Field now static tests
//----------------------------------------------

public test bool fieldNowStaticSimpleAccess()
	= detection(
		|java+method:///main/FieldNowStaticFA/fieldNowStaticClientSimpleAccess()|,
		|java+field:///main/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool fieldNowStaticSuperKeyAccess()
	= detection(
		|java+method:///main/FieldNowStaticExt/fieldNowStaticClientSuperKeyAccess()|,
		|java+field:///main/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool fieldNowStaticNoSuperKeyAccess()
	= detection(
		|java+method:///main/FieldNowStaticExt/fieldNowStaticClientNoSuperKeyAccess()|,
		|java+field:///main/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;    
	
	
//----------------------------------------------
// Field removed tests
//----------------------------------------------

public test bool removedFieldSimpleAccess()
	= detection(
		|java+method:///main/FieldRemovedFA/fieldRemovedClient()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool removedFieldSuperKeyAccess()
	= detection(
		|java+method:///main/FieldRemovedExt/fieldRemovedClientSuper()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool removedFieldNoSuperKeyAccess()
	= detection(
		|java+method:///main/FieldRemovedExt/fieldRemovedClientExt()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: Removed interface fields (constants) are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check fieldAccesss
// relation).
public test bool removedFieldInterface1()
	= detection(
		|java+method:///main/FieldRemovedImp/fieldRemovedClient()|,
		|java+field:///main/IFieldRemoved/FIELD_REMOVED|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// fieldAccesss relation).
public test bool removedFieldInterface1()
	= detection(
		|java+method:///main/FieldRemovedImp/fieldRemovedClientType()|,
		|java+field:///main/IFieldRemoved/FIELD_REMOVED|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;


//----------------------------------------------
// Field type changed tests
//----------------------------------------------

public test bool filedTypeChangedNumericSimpleAccess()
	= detection(
		|java+method:///main/FieldTypeChangedFA/fieldTypeChangedClient()|,
		|java+field:///main/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool filedTypeChangedListSimpleAccess()
	= detection(
		|java+method:///main/FieldTypeChangedFA/fieldTypeChangedClient()|,
		|java+field:///main/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool filedTypeChangedNumericSuperKeyAccess()
	= detection(
		|java+method:///main/FieldTypeChangedExt/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool filedTypeChangedListSuperKeyAccess()
	= detection(
		|java+method:///main/FieldTypeChangedExt/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and accesses the API 
// field without the super keyword, javac registers the field as a 
// field within the client class 
public test bool filedTypeChangedNumericNoSuperKeyAccess()
	= detection(
		|java+method:///main/FieldTypeChangedExt/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool filedTypeChangedListNoSuperKeyAccess()
	= detection(
		|java+method:///main/FieldTypeChangedExt/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///main/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	

//----------------------------------------------
// Method less accessible tests
//----------------------------------------------

public test bool methodLessAccessibleSimpleAccessPub2Pro()
	= detection(
		|java+method:///main/MethodLessAccessibleMI/methodLessAccessiblePub2ProClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodLessAccessibleSimpleAccessPub2PackPriv()
	= detection(
		|java+method:///main/MethodLessAccessibleMI/methodLessAccessiblePub2PackPrivClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool methodLessAccessibleSimpleAccessPub2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMI/methodLessAccessiblePub2PrivClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Is it expected to have these cases??
public test bool methodLessAccessibleSimpleAccessPro2PackPriv()
	= detection(
		|java+method:///main/MethodLessAccessibleMI/methodLessAccessiblePro2PackPrivClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Is it expected to have these cases??
public test bool methodLessAccessibleSimpleAccessPro2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMI/methodLessAccessiblePro2PrivClientSimpleAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool fieldLessAccessibleSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool fieldLessAccessibleSuperKeyAccessPub2PackPriv()	
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool fieldLessAccessibleSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PackPrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool fieldLessAccessibleSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PrivClientSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2PackPriv()	
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePub2PrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PackPrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool fieldLessAccessibleNoSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePro2PrivClientNoSuperKeyAccess()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2Private()|,
		methodInvocation(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool fieldLessAccessibleOverridePub2Pro()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePublic2Protected()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Protected()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool fieldLessAccessibleOverridePub2PackPriv()	
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePublic2PackPriv()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: Solve problem with the M3 method overrides relation. 
public test bool fieldLessAccessibleOverridePub2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessiblePublic2Private()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessiblePublic2Private()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool fieldLessAccessibleOverridePro2PackPriv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessibleProtected2PackPriv()|,
		|java+method:///main/MethodLessAccessible/methodLessAccessibleProtected2PackPriv()|,
		methodOverride(),
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool fieldLessAccessibleOverridePro2Priv()
	= detection(
		|java+method:///main/MethodLessAccessibleMISubtype/methodLessAccessibleProtected2Private()|,
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
		|java+method:///main/MethodNoLongerStaticMI/methodNoLongerStaticClientObject()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodNoLongerStaticSimpleAccessClass()
	= detection(
		|java+method:///main/MethodNoLongerStaticMI/methodNoLongerStaticClientClass()|,
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
		|java+method:///main/MethodNoLongerStaticExt/methodNoLongerStaticSuperKeyAccess()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: we are referring to the parent class object (assuming
// that the method cannot be overriden).
public test bool methodNoLongerStaticNoSuperKeyAccess()
	= detection(
		|java+method:///main/MethodNoLongerStaticExt/methodNoLongerStaticNoSuperKeyAccess()|,
		|java+method:///main/MethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodNoLongerStaticImpl()
	= detection(
		|java+method:///main/MethodNoLongerStaticImp/methodNoLongerStaticClient()|,
		|java+method:///main/IMethodNoLongerStatic/methodNoLongerStatic()|,
		methodInvocation(),
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	

//----------------------------------------------
// Method now abstract tests
//----------------------------------------------

public test bool methodNowAbstractNoOverrideExt()
	= detection(
		|java+class:///main/MethodNowAbstractExt|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Solve problem with the M3 method overrides relation. 
public test bool methodNowAbstractNoOverrideExtWithImpl()
	= detection(
		|java+class:///main/MethodNowAbstractExtWithImpl|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
public test bool methodNowAbstractNoOverrideImpl()
	= detection(
		|java+class:///main/MethodNowAbstractImp|,
		|java+method:///main/IMethodNowAbastract/methodNowAbstract()|,
		methodOverride(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodNowAbstractSuperInvExt()
	= detection(
		|java+method:///main/MethodNowAbstractExt/methodNowAbstractClientSuperKey()|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool methodNowAbstractNoSuperInvExt()
	= detection(
		|java+method:///main/MethodNowAbstractExt/methodNowAbstractClientNoSuperKey()|,
		|java+method:///main/MethodNowAbstract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodNowAbstractSuperInvImpl()
	= detection(
		|java+method:///main/MethodNowAbstractImp/methodNowAbstractClient()|,
		|java+method:///main/IMethodNowAbastract/methodNowAbstract()|,
		methodInvocation(),
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool methodNowAbstractNoOverrideAbstractSubtype()
	= detection(
		|java+class:///main/MethodNowAbstractAbstractSubtype|,
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
		|java+method:///main/MethodNowFinalExt/methodNowFinal()|,
		|java+method:///main/MethodNowFinal/methodNowFinal()|,
		methodOverride(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool methodNowFinalSimpleAccess()
	= detection(
		|java+method:///main/MethodNowFinalExt/methodNowFinalClient()|,
		|java+method:///main/MethodNowFinal/methodNowFinal()|,
		methodInvocation(),
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

	
//----------------------------------------------
// Method now static tests
//----------------------------------------------

public test bool methodNowStaticSimpleAccess()
	= detection(
		|java+method:///main/MethodNowStaticMI/methodNowStaticClient()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
	    
public test bool methodNowStaticSuperKeyAccess()
	= detection(
		|java+method:///main/MethodNowStaticExt/methodNowStaticClientSuperKeyAccess()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodNowStaticNoSuperKeyAccess()
	= detection(
		|java+method:///main/MethodNowStaticExt/methodNowStaticClientNoSuperKeyAccess()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: Modified interface methods are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// methodOverrides relation).
public test bool methodNowStaticOverride()
	= detection(
		|java+method:///main/MethodNowStaticExtOverriden/methodNowStatic()|,
		|java+method:///main/MethodNowStatic/methodNowStatic()|,
		methodOverride(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool methodNowStaticInterface()
	= detection(
		|java+method:///main/MethodNowStaticImp/methodNowStaticClient()|,
		|java+method:///main/IMethodNowStatic/methodNowStatic()|,
		methodInvocation(),
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects; 

    
//----------------------------------------------
// Method removed tests
//----------------------------------------------

public test bool removedMethodSimpleAccess()
	= detection(
		|java+method:///main/MethodRemovedMI/methodRemovedClient()|,
    	|java+method:///main/MethodRemoved/methodRemoved()|,
    	methodInvocation(),
    	methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool removedMethodSuperKeyAccess()
	= detection(
		|java+method:///main/MethodRemovedExt/methodRemovedClientSuper()|,
		|java+method:///main/MethodRemoved/methodRemoved()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
// TODO: If the client class extends an API class and invokes the API  
// method without the super keyword, javac registers the method as a   
// method within the client class.
public test bool removedFieldNoSuperKeyAccess()
	= detection(
		|java+method:///main/MethodRemovedExt/methodRemovedClientExt()|,
		|java+method:///main/MethodRemoved/methodRemoved()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
// TODO: Removed interface methods are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check 
// methodOverrides relation).
public test bool removedFieldMethodOverrides()
	= detection(
		|java+method:///main/MethodRemovedImp/methodRemoved()|,
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
		|java+method:///main/MethodReturnTypeChangedMI/methodReturnTypeChangedNumericClient()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool methodReturnTypeSimpleAccessList()
    = detection(
    	|java+method:///main/MethodReturnTypeChangedMI/methodReturnTypeChangedListClient()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: If the method type changes to a subtype type of the old type 
// no source compatibility error appears.
public test bool methodReturnTypeSuperKeyNumeric()
    = detection(
    	|java+method:///main/MethodReturnTypeChangedExt/methodReturnTypeChangedNumericClientSuperKey()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

public test bool methodReturnTypeSuperKeyNumeric()
	= detection(
		|java+method:///main/MethodReturnTypeChangedExt/methodReturnTypeChangedListClientSuperKey()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the client class extends an API class and accesses the API 
// method without the super keyword, javac registers the method as a 
// method within the client class 
public test bool methodReturnTypeNoSuperKeyNumeric()
    = detection(
    	|java+method:///main/MethodReturnTypeChangedExt/methodReturnTypeChangedNumericClientNoSuperKey()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
    	methodInvocation(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    notin detects;

// TODO: If the client class extends an API class and accesses the API 
// method without the super keyword, javac registers the method as a 
// method within the client class 
public test bool methodReturnTypeNoSuperKeyNumeric()
	= detection(
		|java+method:///main/MethodReturnTypeChangedExt/methodReturnTypeChangedListClientNoSuperKey()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
		methodInvocation(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: problem with the methodOverride relation.
public test bool methodReturnTypeOverrideNumeric()
	= detection(
		|java+method:///main/MethodReturnTypeChangedImp/methodReturnTypeChangedNumeric()|,
		|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedNumeric()|,
		methodOverride(),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

// TODO: problem with the methodOverride relation.
public test bool methodReturnTypeOverrideList()
    = detection(
    	|java+method:///main/MethodReturnTypeChangedImp/methodReturnTypeChangedNumeric()|,
    	|java+method:///main/MethodReturnTypeChanged/methodReturnTypeChangedList()|,
    	methodOverride(),
    	methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
    
//----------------------------------------------
// Constructor removed tests
//----------------------------------------------

public test bool removedConstructorSimpleAccess()
	= detection(
		|java+method:///main/ConstructorRemovedMI/constructorRemovedClientClass()|,
		|java+constructor:///main/ConstructorRemovedClass/ConstructorRemovedClass()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorSimpleAccessParams()
	= detection(
		|java+method:///main/ConstructorRemovedMI/constructorRemovedClientParams()|,
		|java+constructor:///main/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorSimpleAccessNoParams()
	= detection(
		|java+method:///main/ConstructorRemovedMI/constructorRemovedClientNoParams()|,
		|java+constructor:///main/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorSuperConsParams()
	= detection(
		|java+constructor:///main/ConstructorRemovedExtParams/ConstructorRemovedExtParams()|,
		|java+constructor:///main/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool removedConstructorNoSuperConsParams()
	= detection(
		|java+method:///main/ConstructorRemovedExtParams/constructorRemovedExtParamsNoSuper()|,
		|java+constructor:///main/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool removedConstructorSuperConsNoParams()
	= detection(
		|java+constructor:///main/ConstructorRemovedExtNoParams/ConstructorRemovedExtNoParams()|,
		|java+constructor:///main/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorNoSuperConsNoParams()
	= detection(
		|java+method:///main/ConstructorRemovedExtNoParams/constructorRemovedExtNoParamsNoSuper()|,
		|java+constructor:///main/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    