module org::maracas::\test::delta::japicmp::detections::FieldRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool simpleAccess()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedFA/fieldRemovedClient()|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedExt/fieldRemovedClientSuper()|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedExt/fieldRemovedClientExt()|,
		|java+field:///mainclient/fieldRemoved/FieldRemovedExt/fieldRemoved|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
test bool simpleAccessSub()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedFA/fieldRemovedClientSub()|,
		|java+field:///main/fieldRemoved/FieldRemovedSub/fieldRemoved|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool superKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedExtSub/fieldRemovedClientSuper()|,
		|java+field:///main/fieldRemoved/FieldRemovedSub/fieldRemoved|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool noSuperKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedExtSub/fieldRemovedClientExt()|,
		|java+field:///mainclient/fieldRemoved/FieldRemovedExtSub/fieldRemoved|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;