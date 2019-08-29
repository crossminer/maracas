module org::maracas::\test::delta::japicmp::detections::ClassNowAbstractTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


test bool createObject() 
	= detections(
		|java+method:///mainclient/classNowAbstract/ClassNowAbstractMI/createObject()|,
		|java+constructor:///main/classNowAbstract/ClassNowAbstract/ClassNowAbstract()|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool createObjectParams() 
	= detections(
		|java+method:///mainclient/classNowAbstract/ClassNowAbstractMI/createObjectParams()|,
		|java+constructor:///main/classNowAbstract/ClassNowAbstract/ClassNowAbstract()|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool consOverride()
	= detections(
		|java+method:///mainclient/classNowAbstract/ClassNowAbstractExt/ClassNowAbstractExt()|,
		|java+constructor:///main/classNowAbstract/ClassNowAbstract/ClassNowAbstract()|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool consOverrideParams()
	= detections(
		|java+method:///mainclient/classNowAbstract/ClassNowAbstractExt/ClassNowAbstractExt(int)|,
		|java+constructor:///main/classNowAbstract/ClassNowAbstract/ClassNowAbstract(int)|,
		methodInvocation(),
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;