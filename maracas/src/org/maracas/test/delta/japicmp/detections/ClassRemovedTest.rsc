module org::maracas::\test::delta::japicmp::detections::ClassRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::SetUp;

test bool implementsInt() 
	= detection(
		|java+class:///mainclient/classRemoved/ClassRemovedImp|,
		|java+interface:///main/classRemoved/IClassRemoved|,
		|java+interface:///main/classRemoved/IClassRemoved|,
		implements(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool extendsClass() 
	= detection(
		|java+class:///mainclient/classRemoved/ClassRemovedExt|,
		|java+class:///main/classRemoved/ClassRemoved|,
		|java+class:///main/classRemoved/ClassRemoved|,
		extends(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool typeDepIntField()
	= detection(
		|java+field:///mainclient/classRemoved/ClassRemovedTD/i|,
		|java+interface:///main/classRemoved/IClassRemoved|,
		|java+interface:///main/classRemoved/IClassRemoved|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool typeDepClassField()
	= detection(
		|java+field:///mainclient/classRemoved/ClassRemovedTD/c|,
		|java+class:///main/classRemoved/ClassRemoved|,
		|java+class:///main/classRemoved/ClassRemoved|,
		typeDependency(),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;