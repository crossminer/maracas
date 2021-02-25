module org::maracas::\test::delta::japicmp::source::detections::FieldMoreAccessibleTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::source::SetUp;


test bool private2public()
	= detection(
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/private2public|,
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/private2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/private2public|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool private2protected()
	= detection(
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/private2protected|,
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/private2protected|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/private2protected|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// Not reported by JApiCmp	
//test bool private2packageprivate()
//	= detection(
//		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/private2packageprivate|,
//		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/private2packageprivate|,
//		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/private2packageprivate|,
//		declaration(),
//		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
//	in detects;

test bool packageprivate2public()
	= detection(
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2public|,
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/packageprivate2public|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool packageprivate2protected()
	= detection(
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2protected|,
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2protected|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/packageprivate2protected|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

test bool protected2public()
	= detection(
		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/protected2public|,
 		|java+field:///mainclient/fieldMoreAccessible/FieldMoreAccessibleExt/protected2public|,
 		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/protected2public|,
 		declaration(),
 		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
 	in detects;
 	
test bool private2publicSamePkg()
	= detection(
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/private2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/private2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/private2public|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool private2protectedSamePkg()
	= detection(
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/private2protected|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/private2protected|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/private2protected|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

// Not reported by JApiCmp	
//test bool private2packageprivateSamePkg()
//	= detection(
//		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/private2packageprivate|,
//		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/private2packageprivate|,
//		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/private2packageprivate|,
//		declaration(),
//		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
//    in detects;

test bool packageprivate2publicSamePkg()
	= detection(
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/packageprivate2public|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	  
test bool packageprivate2protectedSamePkg()
	= detection(
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2protected|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/packageprivate2protected|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/packageprivate2protected|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
  
test bool protected2publicSamePkg()
	= detection(
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/protected2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessibleExt/protected2public|,
		|java+field:///main/fieldMoreAccessible/FieldMoreAccessible/protected2public|,
		declaration(),
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;