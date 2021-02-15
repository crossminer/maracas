module org::maracas::\test::delta::japicmp::source::detections::MethodNoLongerThrowsCheckedExceptionTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool simpleCall()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionMI/callSuperMethod()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		methodInvocation(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
    
    
test bool simpleSubCall()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionMI/callSubtypeMethod()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionSub/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		methodInvocation(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
    
test bool interfaceCall()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionMI/callInterMethod()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/IMethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/IMethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		methodInvocation(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool callImpMethod()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionMI/callImpMethod()|,
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionImp/noLongerThrowsExcep()|,
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionImp/noLongerThrowsExcep()|,
		methodInvocation(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool callImpMethodInterface()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionMI/callImpMethod()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/IMethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/IMethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		methodInvocation(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	notin detects;
	
test bool overrideSuperMethod()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionExt/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		methodOverride(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool overrideInterMethod()
	= detection(
		|java+method:///mainclient/methodNoLongerThrowsCheckedException/MethodNoLongerThrowsCheckedExceptionImp/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/IMethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		|java+method:///main/methodNoLongerThrowsCheckedException/IMethodNoLongerThrowsCheckedException/noLongerThrowsExcep()|,
		methodOverride(),
		methodNoLongerThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
