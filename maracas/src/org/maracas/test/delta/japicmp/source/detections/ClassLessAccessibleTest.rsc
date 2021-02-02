module org::maracas::\test::delta::japicmp::source::detections::ClassLessAccessibleTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;
import org::maracas::\test::delta::japicmp::source::TestUtils;

test bool pub2proExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2ProExt$ClassLessAccessiblePub2ProExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Pro$ClassLessAccessiblePub2ProInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Pro$ClassLessAccessiblePub2ProInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool pub2packprivExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2PackPrivExt|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPriv|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPriv|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool pub2privExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2PrivExt$ClassLessAccessiblePub2PrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Priv$ClassLessAccessiblePub2PrivInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Priv$ClassLessAccessiblePub2PrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool pro2packprivExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePro2PackPrivExt$ClassLessAccessiblePro2PackPrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePro2PackPriv$ClassLessAccessiblePro2PackPrivInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePro2PackPriv$ClassLessAccessiblePro2PackPrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool pro2privExt()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePro2PrivExt$ClassLessAccessiblePro2PrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePro2Priv$ClassLessAccessiblePro2PrivInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePro2Priv$ClassLessAccessiblePro2PrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

// Fails due to https://github.com/crossminer/maracas/issues/76
test bool packpriv2privExt()
	= detection(
		|java+class:///main/classLessAccessible/ClassLessAccessiblePackPriv2PrivExt$ClassLessAccessiblePackPriv2PrivExtInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePackPriv2Priv$ClassLessAccessiblePackPriv2PrivInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePackPriv2Priv$ClassLessAccessiblePackPriv2PrivInner|,
		extends(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

test bool pub2packprivImpDiffPack()
	= detection(
		|java+class:///mainclient/classLessAccessible/ClassLessAccessiblePub2PackPrivImp|,
		|java+interface:///main/classLessAccessible/IClassLessAccessiblePub2PackPriv|,
		|java+interface:///main/classLessAccessible/IClassLessAccessiblePub2PackPriv|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool pub2packprivImpSamePack()
	= detection(
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPrivImp|,
		|java+interface:///main/classLessAccessible/IClassLessAccessiblePub2PackPriv|,
		|java+interface:///main/classLessAccessible/IClassLessAccessiblePub2PackPriv|,
		implements(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool pub2packPrivRef()
	= detection(
		|java+method:///mainclient/classLessAccessible/ClassLessAccessiblePub2PackPrivExt/instantiatePub2PackPriv()|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPriv|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPriv|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
test bool pub2privRef()
	= detection(
		|java+method:///mainclient/classLessAccessible/ClassLessAccessiblePub2PrivExt/instantiatePub2Priv()|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Priv$ClassLessAccessiblePub2PrivInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Priv$ClassLessAccessiblePub2PrivInner|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool pub2proRef()
	= detection(
		|java+method:///mainclient/classLessAccessible/ClassLessAccessiblePub2ProExt/instantiatePub2Pro()|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Pro$ClassLessAccessiblePub2ProInner|,
		|java+class:///main/classLessAccessible/ClassLessAccessiblePub2Pro$ClassLessAccessiblePub2ProInner|,
		typeDependency(),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool noExtraDetections()
	=  noDetectionOn(detects, |java+class:///main/classLessAccessible/ClassLessAccessiblePackPriv2PrivExt|)
	&& noDetectionOn(detects, |java+class:///main/classLessAccessible/ClassLessAccessiblePub2PackPrivImp|)
	;
