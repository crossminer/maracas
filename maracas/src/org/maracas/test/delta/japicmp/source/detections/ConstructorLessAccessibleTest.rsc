module org::maracas::\test::delta::japicmp::source::detections::ConstructorLessAccessibleTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool simpleAccessPub2Pro()
	= detection(
		|java+method:///mainclient/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool simpleAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool simpleAccessPub2Priv()
	= detection(
		|java+method:///mainclient/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool anonymousConstructorAccess()
	= detection(
		|java+class:///main/constructorLessAccessible/ConstructorLessAccessibleMI$1|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superAccessPub2Pro()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Pro/ConstructorLessAccessibleExtPub2Pro()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
  		
test bool superAccessPub2PackPriv()	
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2PackPriv/ConstructorLessAccessibleExtPub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superAccessPub2Priv()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Priv/ConstructorLessAccessibleExtPub2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superAccessPro2PackPriv()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2PackPriv/ConstructorLessAccessibleExtPro2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superAccessPro2Priv()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2Priv/ConstructorLessAccessibleExtPro2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2Priv/ConstructorLessAccessiblePro2Priv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2Priv/ConstructorLessAccessiblePro2Priv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superAccessPub2ProParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Pro/ConstructorLessAccessibleExtPub2Pro(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Pro/ConstructorLessAccessiblePub2Pro(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool superAccessPub2PackPrivParams()	
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2PackPriv/ConstructorLessAccessibleExtPub2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool superAccessPub2PrivParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPub2Priv/ConstructorLessAccessibleExtPub2Priv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2Priv/ConstructorLessAccessiblePub2Priv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superAccessPro2PackPrivParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2PackPriv/ConstructorLessAccessibleExtPro2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superAccessPro2PrivParams()
	= detection(
		|java+constructor:///mainclient/constructorLessAccessible/ConstructorLessAccessibleExtPro2Priv/ConstructorLessAccessibleExtPro2Priv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2Priv/ConstructorLessAccessiblePro2Priv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2Priv/ConstructorLessAccessiblePro2Priv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool simpleAccessPub2PackPrivSamePack()
	= detection(
		|java+method:///main/constructorLessAccessible/ConstructorLessAccessibleMI/clientPublic()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool superAccessPub2PackPrivSamePack()	
	= detection(
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessibleExtPub2PackPriv/ConstructorLessAccessibleExtPub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool superAccessPro2PackPrivSamePack()
	= detection(
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessibleExtPro2PackPriv/ConstructorLessAccessibleExtPro2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv()|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv()|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool superAccessPub2PackPrivParamsSamePack()	
	= detection(
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessibleExtPub2PackPriv/ConstructorLessAccessibleExtPub2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePub2PackPriv/ConstructorLessAccessiblePub2PackPriv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
	
test bool superAccessPro2PackPrivParamsSamePack()
	= detection(
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessibleExtPro2PackPriv/ConstructorLessAccessibleExtPro2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv(int)|,
		|java+constructor:///main/constructorLessAccessible/ConstructorLessAccessiblePro2PackPriv/ConstructorLessAccessiblePro2PackPriv(int)|,
		methodInvocation(),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;