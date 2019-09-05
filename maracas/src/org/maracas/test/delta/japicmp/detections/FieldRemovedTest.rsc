module org::maracas::\test::delta::japicmp::detections::FieldRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool simpleAccess()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedFA/fieldRemovedClient()|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool superKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedExt/fieldRemovedClientSuper()|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool noSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemoved/FieldRemovedExt/fieldRemovedClientExt()|,
		|java+field:///main/fieldRemoved/FieldRemoved/fieldRemoved|,
		fieldAccess(),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;