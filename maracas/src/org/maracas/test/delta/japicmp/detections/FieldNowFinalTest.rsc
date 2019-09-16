module org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool simpleAccessAssign() 
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalFA/fieldNowFinalAssignment()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool simpleAccessNoAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalFA/fieldNowFinalNoAssignment()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool superKeyAccessAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalAssignmentSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool superKeyAccessNoAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalNoAssignmentSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool noSuperKeyAccessAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalAssignmentNoSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// TODO: We must identify field assignment cases. Flybytes 
// seems to be an option.
public test bool noSuperKeyAccessNoAssign()
	= detection(
		|java+method:///mainclient/fieldNowFinal/FieldNowFinalExt/fieldNowFinalNoAssignmentNoSuperKey()|,
		|java+field:///main/fieldNowFinal/FieldNowFinal/fieldFinal|,
		fieldAccess(),
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;