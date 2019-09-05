module org::maracas::\test::delta::japicmp::detections::MethodRemovedInSuperclassTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;

test bool accessSuperS()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuperS()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool accessSuperSAbs()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuperSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool accessSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuper()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool accessSuperAbs()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuperAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool callSuperSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/callSuperSMethod()|,
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/methodRemovedS()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool callSuperSSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/callSuperSSMethod()|,
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/methodRemovedSS()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool callSuperSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/callSuperSMethod()|,
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/methodRemovedS()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool callSuperSSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/callSuperSSMethod()|,
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/methodRemovedSS()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overrideSuperSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/methodRemovedSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
//test bool overrideSuperSSMethodExtSuper();

test bool overrideSuperSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/methodRemovedSSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		methodInvocation(),
		methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
//test bool overrideSuperSSMethodExtSSuper();