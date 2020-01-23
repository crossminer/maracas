module org::maracas::\test::delta::japicmp::detections::SuperclassRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool listConsExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listCons()|,
		|java+field:///main/superclassRemoved/SuperclassRemoved/LIST|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool listConsDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listConsDirect()|,
		|java+field:///mainclient/superclassRemoved/SuperclassRemovedExt/LIST|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listConsSuperExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listConsSuper()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/LIST|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool listConsTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/listCons()|,
		|java+field:///main/superclassRemoved/SuperclassRemoved/LIST|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listConsSuperTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/listConsInter()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/LIST|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool staticMethExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticM()|,
		|java+method:///main/superclassRemoved/SuperclassRemoved/staticMeth()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool staticMethDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticMDirect()|,
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticMeth()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool staticMethSuperExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticMSuper()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/staticMeth()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool staticMethTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/staticM()|,
		|java+method:///main/superclassRemoved/SuperclassRemoved/staticMeth()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool staticMethSuperTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/staticMSuper()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/staticMeth()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
