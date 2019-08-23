module org::maracas::\test::delta::JApiCmpDetectorTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

loc apiOld = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-old.jar|;
loc apiNew = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-new.jar|;
loc client = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/comp-changes-client.jar|;

M3 m3ApiOld = createM3FromJar(apiOld);
M3 m3Client = createM3FromJar(client);

list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
set[Detection] detects = detections(m3Client, m3ApiOld, delta);


//----------------------------------------------
// Field removed tests
//----------------------------------------------

public test bool removedFieldSimpleAccess()
	= detection(
		|java+method:///main/FieldRemovedFA/fieldRemovedClient()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAcces(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool removedFieldSuperKeyAccess()
	= detection(
		|java+method:///main/FieldRemovedExt/fieldRemovedClientSuper()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAcces(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: If the client class extends an API class and accesses the API  
// field without the super keyword, javac registers the field as a field  
// within the client class.
public test bool removedFieldNoSuperKeyAccess()
	= detection(
		|java+method:///main/FieldRemovedExt/fieldRemovedClientExt()|,
		|java+field:///main/FieldRemoved/fieldRemoved|,
		fieldAcces(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: Removed interface fields (constants) are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check fieldAccess
// relation).
public test bool removedFieldInterface1()
	= detection(
		|java+method:///main/FieldRemovedImp/fieldRemovedClient()|,
		|java+field:///main/IFieldRemoved/FIELD_REMOVED|,
		fieldAcces(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// TODO: Removed interface fields (constants) are not identified as a change.
// This is not a JApiCmp problem but rather a Rascal M3 issue (check fieldAccess
// relation).
public test bool removedFieldInterface1()
	= detection(
		|java+method:///main/FieldRemovedImp/fieldRemovedClientType()|,
		|java+field:///main/IFieldRemoved/FIELD_REMOVED|,
		fieldAcces(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
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