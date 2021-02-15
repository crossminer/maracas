module org::maracas::\test::delta::japicmp::source::detections::SuperclassRemovedTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool intConsExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/intCons()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/CTE|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool intConsDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/intConsDirect()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/CTE|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool intConsSuperExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/intConsSuper()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/CTE|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
    
test bool listConsExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listCons()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/LIST|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		fieldAccess(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool listConsDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/listConsDirect()|,
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/LIST|,
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
		|java+field:///main/superclassRemoved/SuperSuperclassRemoved/LIST|,
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
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/staticMeth()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodInvocation(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool staticMethDirectExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExt/staticMDirect()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/staticMeth()|,
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
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/staticMeth()|,
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

test bool methodAbsImp()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedImp/methodAbs()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/methodAbs()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodOverride(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool methodAbsExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedExtAbs/methodAbs()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/methodAbs()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodOverride(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool methodAbsImpMulti()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperclassRemovedImpMulti/methodAbs()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/methodAbs()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodOverride(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool methodAbsSuperExt()
	= detection(
		|java+method:///mainclient/superclassRemoved/SuperSuperclassRemovedExt/methodAbs()|,
		|java+method:///main/superclassRemoved/SuperSuperclassRemoved/methodAbs()|,
		|java+class:///main/superclassRemoved/SuperSuperclassRemoved|,
		methodOverride(),
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	