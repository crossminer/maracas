module org::maracas::\test::delta::japicmp::source::detections::ClassNowFinalTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool abstractClass() 
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalAbsExt|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool abstractClassSup()
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalAbsExtSup|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool nonAbstractClass() 
	= detection(
		|java+class:///mainclient/classNowFinal/ClassNowFinalExt|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool abstractMethodOverr() 
	= detection(
		|java+method:///mainclient/classNowFinal/ClassNowFinalAbsExt/m()|,
		|java+method:///main/classNowFinal/ClassNowFinalAbs/m()|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		methodOverride(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool nonAbstractMethodOverr() 
	= detection(
		|java+method:///mainclient/classNowFinal/ClassNowFinalExt/m()|,
		|java+method:///main/classNowFinal/ClassNowFinal/m()|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		methodOverride(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool anonymousNonAbstract()
	= detection(
		|java+anonymousClass:///mainclient/classNowFinal/ClassNowFinalAnonymousSub/classNowFinalAnonymousSub()/$anonymous1|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		|java+class:///main/classNowFinal/ClassNowFinal|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool anonymousAbstract()
	= detection(
		|java+method:///mainclient/classNowFinal/ClassNowFinalAnonymousSub/classNowFinalAnonymousSubAbs()/$anonymous1/m()|,
		|java+method:///main/classNowFinal/ClassNowFinalAbs/m()|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		methodOverride(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool anonymousAbstractExt()
	= detection(
		|java+anonymousClass:///mainclient/classNowFinal/ClassNowFinalAnonymousSub/classNowFinalAnonymousSubAbs()/$anonymous1|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		|java+class:///main/classNowFinal/ClassNowFinalAbs|,
		extends(),
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	in detects;