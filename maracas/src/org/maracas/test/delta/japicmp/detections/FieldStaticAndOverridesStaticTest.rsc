module org::maracas::\test::delta::japicmp::detections::FieldStaticAndOverridesStaticTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


test bool staticAccessSubtype() 
	= detection(
		|java+method:///mainclient/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStaticFA/accessFieldFromSubtype()|,
		|java+field:///main/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStatic/fieldStatic|,
		fieldAccess(),
		fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superAccessSubtype()
	= detection(
		|java+method:///mainclient/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStaticExt/accessFieldFromSubtypeSuper()|,
		|java+field:///main/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStatic/fieldStatic|,
		fieldAccess(),
		fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool noSuperAccessSubtype()
	= detection(
		|java+method:///mainclient/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStaticExt/accessFieldFromSubtypeNoSuper()|,
		|java+field:///main/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStatic/fieldStatic|,
		fieldAccess(),
		fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool staticAccessMultiSubtype() 
	= detection(
		|java+method:///mainclient/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStaticMultiFA/accessFieldFromSubtype()|,
		|java+field:///main/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStatic/fieldStatic|,
		fieldAccess(),
		fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superAccessMultiSubtype()
	= detection(
		|java+method:///mainclient/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStaticMultiExt/accessFieldFromSubtypeSuper()|,
		|java+field:///main/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStatic/fieldStatic|,
		fieldAccess(),
		fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool noSuperAccessMultiSubtype()
	= detection(
		|java+method:///mainclient/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStaticMultiExt/accessFieldFromSubtypeNoSuper()|,
		|java+field:///main/fieldStaticAndOverridesStatic/FieldStaticAndOverridesStatic/fieldStatic|,
		fieldAccess(),
		fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;