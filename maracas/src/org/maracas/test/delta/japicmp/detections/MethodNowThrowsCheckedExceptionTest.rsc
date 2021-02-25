module org::maracas::\test::delta::japicmp::detections::MethodNowThrowsCheckedExceptionTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool simpleCall()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callSuperMethod()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool simpleSubCall()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callSubtypeMethod()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionSub/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
    
test bool interfaceCall()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callInterMethod()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool callImpMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callImpMethod()|,
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionImp/nowThrowsExcep()|,
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionImp/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool callImpMethodInterface()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callImpMethod()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;

// Overriding a method in subclass without raising its original exception is perfectly fine
test bool overrideSuperMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionExt/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodOverride(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;

// Overriding a method in subclass without raising its original exception is perfectly fine
test bool overrideInterMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionImp/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodOverride(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
