module org::maracas::\test::delta::japicmp::detections::MethodNowThrowsCheckedExceptionTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;

test bool callSuperMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callSuperMethod()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool callInterMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callInterMethod()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool callSubtypeMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callSubtypeMethod()|,
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionExt/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool callImpMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionMI/callImpMethod()|,
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionImp/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool overrideSuperMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionExt/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/MethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool overrideInterMethod()
	= detection(
		|java+method:///mainclient/methodNowThrowsCheckedException/MethodNowThrowsCheckedExceptionImp/nowThrowsExcep()|,
		|java+method:///main/methodNowThrowsCheckedException/IMethodNowThrowsCheckedException/nowThrowsExcep()|,
		methodInvocation(),
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;