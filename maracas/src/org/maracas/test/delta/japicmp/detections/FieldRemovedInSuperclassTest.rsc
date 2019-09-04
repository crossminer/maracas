module org::maracas::\test::delta::japicmp::detections::FieldRemovedInSuperclassTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


test bool accessSuper()
	= detection(
		|java+method:///mainclient/fieldRemovedInSuperclass/FieldRemovedInSuperclassFA/accessSuper()|,
		|java+field:///main/fieldRemovedInSuperclass/SSFieldRemovedInSuperclass/removedField|,
		fieldAccess(),
		fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool accessSub()
	= detection(
		|java+method:///mainclient/fieldRemovedInSuperclass/FieldRemovedInSuperclassFA/accessSub()|,
		|java+field:///main/fieldRemovedInSuperclass/SSFieldRemovedInSuperclass/removedField|,
		fieldAccess(),
		fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool extSubSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemovedInSuperclass/FieldRemovedInSuperclassExt/accessSuperKey()|,
		|java+field:///main/fieldRemovedInSuperclass/SSFieldRemovedInSuperclass/removedField|,
		fieldAccess(),
		fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool extSubNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemovedInSuperclass/FieldRemovedInSuperclassExt/accessNoSuperKey()|,
		|java+field:///main/fieldRemovedInSuperclass/FieldRemovedInSuperclass/removedField|,
		fieldAccess(),
		fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool extSupSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemovedInSuperclass/SFieldRemovedInSuperclassExt/accessSuperKey()|,
		|java+field:///main/fieldRemovedInSuperclass/SSFieldRemovedInSuperclass/removedField|,
		fieldAccess(),
		fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool extSupNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldRemovedInSuperclass/SFieldRemovedInSuperclassExt/accessNoSuperKey()|,
		|java+field:///main/fieldRemovedInSuperclass/SFieldRemovedInSuperclass/removedField|,
		fieldAccess(),
		fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
