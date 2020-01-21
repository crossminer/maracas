module org::maracas::\test::delta::japicmp::detections::MethodMoreAccessibleTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::SetUp;


test bool protected2public()
	= detection(
		|java+method:///mainclient/methodMoreAccessible/MethodMoreAccessibleExt/protected2public()|,
		|java+method:///main/methodMoreAccessible/MethodMoreAccessible/protected2public()|,
		methodOverride(),
		methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool protected2publicSamePkg()
	= detection(
		|java+method:///main/methodMoreAccessible/MethodMoreAccessibleExt/protected2public()|,
		|java+method:///main/methodMoreAccessible/MethodMoreAccessible/protected2public()|,
		methodOverride(),
		methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool pkgProtected2protectedSamePkg()
	= detection(
		|java+method:///main/methodMoreAccessible/MethodMoreAccessibleExt/pkgProtected2protected()|,
		|java+method:///main/methodMoreAccessible/MethodMoreAccessible/pkgProtected2protected()|,
		methodOverride(),
		methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool pkgProtected2publicSamePkg()
	= detection(
		|java+method:///main/methodMoreAccessible/MethodMoreAccessibleExt/pkgProtected2public()|,
		|java+method:///main/methodMoreAccessible/MethodMoreAccessible/pkgProtected2public()|,
		methodOverride(),
		methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
