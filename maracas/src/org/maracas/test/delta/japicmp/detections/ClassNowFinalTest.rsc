module org::maracas::\test::delta::japicmp::detections::ClassNowFinalTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;

test bool abstractClass() 
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalAbsExt|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool nonAbstractClass() 
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalExt|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool abstractMethodOverr() 
	= detection(
		|java+method:///mainclient/classNowFinal/ClassNowFinalAbsExt/m()|,
		|java+method:///main/classNowFinal/ClassNowFinalAbs/m()|,
		methodOverride(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool nonAbstractMethodOverr() 
	= detection(
		|java+method:///mainclient/classNowFinal/ClassNowFinalExt/m()|,
		|java+method:///main/classNowFinal/ClassNowFinal/m()|,
		methodOverride(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool anonymousNonAbstract()
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalAnonymousSub$1|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool anonymousAbstract()
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalAnonymousSub$2|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
