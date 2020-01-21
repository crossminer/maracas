module org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool simpleAccessAssign() 
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalFA/fieldNowFinalAssignment()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
test bool simpleAccessNoAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalFA/fieldNowFinalNoAssignment()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool superKeyAccessAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalAssignmentSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
test bool superKeyAccessNoAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalNoAssignmentSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool noSuperKeyAccessAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalAssignmentNoSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
test bool noSuperKeyAccessNoAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalNoAssignmentNoSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool simpleAccessAssign() 
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalFA/fieldNowFinalAssignmentSub()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
test bool simpleAccessNoAssignSub()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalFA/fieldNowFinalNoAssignmentSub()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool superKeyAccessAssignSub()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExtSub/fieldNowFinalAssignmentSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
test bool superKeyAccessNoAssignSub()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExtSub/fieldNowFinalNoAssignmentSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool noSuperKeyAccessAssignSub()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExtSub/fieldNowFinalAssignmentNoSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
test bool noSuperKeyAccessNoAssignSub()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExtSub/fieldNowFinalNoAssignmentNoSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;