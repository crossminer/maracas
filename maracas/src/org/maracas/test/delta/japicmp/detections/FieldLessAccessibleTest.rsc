module org::maracas::\test::delta::japicmp::detections::FieldLessAccessibleTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool simpleAccessPub2Pro()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFA/fieldLessAccessibleClientPub2Pro()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFA/fieldLessAccessibleClientPub2PackPriv()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessPub2Priv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFA/fieldLessAccessibleClientPub2Priv()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool superKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2ProSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool superKeyAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PackPrivSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
public test bool superKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PrivSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool superKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PackPrivSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/protected2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool superKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PrivSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/protected2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperKeyAccessPub2Pro()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2ProNoSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

public test bool noSuperKeyAccessPub2PackPriv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PackPrivNoSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperKeyAccessPub2Priv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPub2PrivNoSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/public2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
public test bool noSuperKeyAccessPro2PackPriv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PackPrivNoSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/protected2packageprivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperKeyAccessPro2Priv()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleClientPro2PrivNoSuperKey()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessible/protected2private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool simpleAccessPub2PackPrivSamePack()
	= detection(
		|java+method:///main/methodLessAccessible/FieldLessAccessibleMI/clientPublic()|,
		|java+field:///main/methodLessAccessible/FieldLessAccessible/public2packageprivate|,
		methodInvocation(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool simpleAccessPro2PackPrivSamePack()
	= detection(
		|java+method:///main/methodLessAccessible/FieldLessAccessibleMI/clientProtected()|,
		|java+field:///main/methodLessAccessible/FieldLessAccessible/protected2packageprivate|,
		methodInvocation(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;

test bool superKeySuperPublic2Private()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleSuperPublic2Private()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superPublic2Private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superKeySuperPublic2Protected()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleSuperPublic2Protected()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superPublic2Protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superKeySuperPublic2PackagePrivate()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleSuperPublic2PackagePrivate()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superPublic2PackagePrivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool superKeySuperProtected2Private()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFASubtype/fieldLessAccessibleSuperProtected2Private()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superProtected2Private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessSuperPublic2Private()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFA/fieldLessAccessibleSuperPublic2Private()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superPublic2Private|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessSuperPublic2Protected()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFA/fieldLessAccessibleSuperPublic2Protected()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superPublic2Protected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessSuperPublic2PackagePrivate()
	= detection(
		|java+method:///mainclient/fieldLessAccessible/FieldLessAccessibleFA/fieldLessAccessibleSuperPublic2PackagePrivate()|,
		|java+field:///main/fieldLessAccessible/FieldLessAccessibleSuper/superPublic2PackagePrivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
