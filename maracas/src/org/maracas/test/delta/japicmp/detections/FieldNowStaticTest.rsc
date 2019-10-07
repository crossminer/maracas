module org::maracas::\test::delta::japicmp::detections::FieldNowStaticTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool simpleAccess()
	= detection(
		|java+method:///mainclient/fieldNowStatic/FieldNowStaticFA/fieldNowStaticClientSimpleAccess()|,
		|java+field:///main/fieldNowStatic/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/fieldNowStatic/FieldNowStaticExt/fieldNowStaticClientSuperKeyAccess()|,
		|java+field:///main/fieldNowStatic/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldNowStatic/FieldNowStaticExt/fieldNowStaticClientNoSuperKeyAccess()|,
		|java+field:///main/fieldNowStatic/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;    

public test bool simpleAccessSub()
	= detection(
		|java+method:///mainclient/fieldNowStatic/FieldNowStaticFA/fieldNowStaticClientSimpleAccessSub()|,
		|java+field:///main/fieldNowStatic/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool superKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldNowStatic/FieldNowStaticExtSub/fieldNowStaticClientSuperKeyAccess()|,
		|java+field:///main/fieldNowStatic/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldNowStatic/FieldNowStaticExtSub/fieldNowStaticClientNoSuperKeyAccess()|,
		|java+field:///main/fieldNowStatic/FieldNowStatic/MODIFIED_FIELD|,
		fieldAccess(),
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects; 
