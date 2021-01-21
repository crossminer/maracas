module org::maracas::\test::delta::japicmp::source::detections::FieldTypeChangedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool numericSimpleAccess()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedFA/fieldTypeChangedClient()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listSimpleAccess()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedFA/fieldTypeChangedClient()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool numericSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExt/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool listSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExt/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool numericNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExt/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///mainclient/fieldTypeChanged/FieldTypeChangedExt/fieldNumeric|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool listNoSuperKeyAccess()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExt/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///mainclient/fieldTypeChanged/FieldTypeChangedExt/fieldList|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	

test bool numericSimpleAccessSub()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedFA/fieldTypeChangedClientSub()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChangedSub/fieldNumeric|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listSimpleAccessSub()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedFA/fieldTypeChangedClientSub()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChangedSub/fieldList|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool numericSuperKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExtSub/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChangedSub/fieldNumeric|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool listSuperKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExtSub/fieldTypeChangedClientSuperKeyAccess()|,
		|java+field:///main/fieldTypeChanged/FieldTypeChangedSub/fieldList|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool numericNoSuperKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExtSub/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///mainclient/fieldTypeChanged/FieldTypeChangedExtSub/fieldNumeric|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldNumeric|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: If the field type changes to a subtype type of the old type 
// no source compatibility error appears.
test bool listNoSuperKeyAccessSub()
	= detection(
		|java+method:///mainclient/fieldTypeChanged/FieldTypeChangedExtSub/fieldTypeChangedClientNoSuperKeyAccess()|,
		|java+field:///mainclient/fieldTypeChanged/FieldTypeChangedExtSub/fieldList|,
		|java+field:///main/fieldTypeChanged/FieldTypeChanged/fieldList|,
		fieldAccess(),
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;