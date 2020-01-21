module org::maracas::\test::delta::japicmp::detections::InterfaceRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool listConsExt()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedExt/listCons()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		fieldAccess(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool listConsInterExt()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedExt/listConsInter()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		fieldAccess(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool listConsDirectExt()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedExt/listConsDirect()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		fieldAccess(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool listConsTD()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedTD/listCons()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		fieldAccess(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool listConsInterTD()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedTD/listConsInter()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		fieldAccess(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
		
test bool defaultExt() 
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedExt/defaultM()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		methodInvocation(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool staticTD()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedTD/staticM()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		methodInvocation(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool staticExt()
	= detection(
		|java+method:///mainclient/interfaceRemoved/InterfaceRemovedExt/staticM()|,
		|java+interface:///main/interfaceRemoved/IInterfaceRemoved|,
		methodInvocation(),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
