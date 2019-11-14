module org::maracas::\test::delta::japicmp::detections::SuperclassRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


test bool listConsExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listCons()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool listConsDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listConsDirect()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listConsSuperExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listConsSuper()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool listConsTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/listCons()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listConsSuperTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/listConsSuper()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool staticMethExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticM()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool staticMethDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticMDirect()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool staticMethSuperExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticMSuper()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool staticMethTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/staticM()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool staticMethSuperTD()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedTD/staticMSuper()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
