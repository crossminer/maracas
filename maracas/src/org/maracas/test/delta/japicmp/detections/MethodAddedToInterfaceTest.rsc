module org::maracas::\test::delta::japicmp::detections::MethodAddedToInterfaceTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool implements1() 
	= detection(
		|java+class:///mainclient/methodAddedToInterface/MethodAddedToInterfaceImp1|,
		|java+method:///main/methodAddedToInterface/IMethodAddedToInterface/newMethod()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool implements2()
	= detection(
		|java+class:///mainclient/methodAddedToInterface/MethodAddedToInterfaceImp2|,
		|java+method:///main/methodAddedToInterface/IMethodAddedToInterface/newMethod()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;

test bool innerInterfaceImpl() 
	= detection(
		|java+class:///mainclient/methodAddedToInterface/MethodAddedToInterfaceInnerImp$Inner|,
		|java+method:///main/methodAddedToInterface/IMethodAddedToInterfaceInner$I/newMethod()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
	
test bool innerInterfaceExt() 
	= detection(
		|java+class:///mainclient/methodAddedToInterface/MethodAddedToInterfaceInnerExt$Inner|,
		|java+method:///main/methodAddedToInterface/MethodAddedToInterfaceInner$I/newMethod()|,
		implements(),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	in detects;
    
    