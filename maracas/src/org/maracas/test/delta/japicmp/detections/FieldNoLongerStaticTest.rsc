module org::maracas::\test::delta::japicmp::detections::FieldNoLongerStaticTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool simpleAccess() 
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticFA/fieldNoLongerStaticClient()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
// TODO: the super keyword refers to the parent class OBJECT.
// Even though it is a bad practice to access class fields 
// through objects it is not a problem when the we refer to 
// an instance field. 
public test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticExt/fieldNoLongerStaticClientSuperKey()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticExt/fieldNoLongerStaticClientNoSuperKey()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStatic/fieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;