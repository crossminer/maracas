module org::maracas::\test::delta::japicmp::detections::ClassNoLongerPublicTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool methTD()
	= detection(
		|java+method:///mainclient/classNoLongerPublic/ClassNoLongerPublicTD/refClassNoLongerPublic()|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool consTD()
	= detection(
		|java+constructor:///mainclient/classNoLongerPublic/ClassNoLongerPublicTD/ClassNoLongerPublicTD(main.classNoLongerPublic.ClassNoLongerPublic)|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool fieldTD() 
	= detection(
		|java+field:///mainclient/classNoLongerPublic/ClassNoLongerPublicTD/field|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool extClass()
	= detection(
		|java+class:///mainclient/classNoLongerPublic/ClassNoLongerPublicExt|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		extends(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool impInterface()
	= detection(
		|java+class:///mainclient/classNoLongerPublic/ClassNoLongerPublicImp|,
		|java+interface:///main/classNoLongerPublic/IClassNoLongerPublic|,
		|java+interface:///main/classNoLongerPublic/IClassNoLongerPublic|,
		implements(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool accessSuperFieldExt()
	= detection(
		|java+method:///mainclient/classNoLongerPublic/ClassNoLongerPublicExt/accessSuperField()|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool invokeSuperMethodExt()
	= detection(
		|java+method:///mainclient/classNoLongerPublic/ClassNoLongerPublicExt/accessSuperMethod()|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		|java+class:///main/classNoLongerPublic/ClassNoLongerPublic|,
		typeDependency(),
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	in detects;