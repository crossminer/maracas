module org::maracas::\test::delta::japicmp::source::detections::MethodRemovedInSuperclassTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool accessSuperS()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuperS()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool accessSuperSAbs()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuperSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool accessSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuper()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool accessSuperAbs()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassFA/accessSuperAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool callSuperSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/callSuperSMethod()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool callSuperSSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/callSuperSSMethod()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool callSuperSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/callSuperSMethod()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedS()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool callSuperSSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/callSuperSSMethod()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSS()|,
		methodInvocation(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overrideSuperSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/methodRemovedSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		methodOverride(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool overrideSuperSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/methodRemovedSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SMethodRemovedInSuperclass/methodRemovedSAbs()|,
		methodOverride(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overrideSuperSSMethodExtSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/MethodRemovedInSuperclassExt/methodRemovedSSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		methodOverride(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool overrideSuperSSMethodExtSSuper()
	= detection(
		|java+method:///mainclient/methodRemovedInSuperclass/SMethodRemovedInSuperclassExt/methodRemovedSSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		|java+method:///main/methodRemovedInSuperclass/SSMethodRemovedInSuperclass/methodRemovedSSAbs()|,
		methodOverride(),
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
