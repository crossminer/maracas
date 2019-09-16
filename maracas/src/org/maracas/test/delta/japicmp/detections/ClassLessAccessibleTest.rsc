module org::maracas::\test::delta::japicmp::detections::ClassLessAccessibleTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


test bool pub2proExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2ProExt$ClassLessAccessiblePub2ProExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Pro$ClassLessAccessiblePub2ProInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool pub2packprivExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2PackPrivExt|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPriv|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool pub2privExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2PrivExt$ClassLessAccessiblePub2PrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Priv$ClassLessAccessiblePub2PrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool pro2packprivExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePro2PackPrivExt$ClassLessAccessiblePro2PackPrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePro2PackPriv$ClassLessAccessiblePro2PackPrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool pro2privExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePro2PrivExt$ClassLessAccessiblePro2PrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePro2Priv$ClassLessAccessiblePro2PrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool packpriv2privExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePackPriv2PrivExt$ClassLessAccessiblePackPriv2PrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePackPriv2Priv$ClassLessAccessiblePackPriv2PrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool pub2packprivImpDiffPack()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2PackPrivImp|,
		|java+interface:///main/classLessAccessible/IClassLessAccessiblePub2PackPriv|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool pub2packprivImpSamePack()
	= detection(
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPrivImp|,
		|java+interface:///main/classLessAccessible/IClassLessAccessiblePub2PackPriv|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;