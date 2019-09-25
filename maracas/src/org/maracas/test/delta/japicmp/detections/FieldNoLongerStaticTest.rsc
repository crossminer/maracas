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

test bool superKeyAccessSuper()
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticExt/fieldNoLongerStaticClientSuperSuperKey()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStaticSuper/superFieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool noSuperKeyAccessSuper()
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticExt/fieldNoLongerStaticClientSuperNoSuperKey()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStaticSuper/superFieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool simpleAccessSuper1()
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticFA/fieldNoLongerStaticSuperClient1()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStaticSuper/superFieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool simpleAccessSuper2()
	= detection(
		|java+method:///mainclient/fieldNoLongerStatic/FieldNoLongerStaticFA/fieldNoLongerStaticSuperClient2()|,
		|java+field:///main/fieldNoLongerStatic/FieldNoLongerStaticSuper/superFieldStatic|,
		fieldAccess(),
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
