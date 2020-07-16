module org::maracas::\test::delta::jezek_benchmark::detections::AccessModifierClazzFieldAccessDecreaseTest

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::detections::Common;
import org::maracas::\test::delta::jezek_benchmark::SetUp;


test bool occurrence()
	= containsCase("accessModifierClazzFieldAccessDecrease") == true;
	
test bool publicToProtected()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldPublicToProtected|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldPublicToProtected|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	notin detects;
    
test bool publicToNon()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldPublicToNon|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldPublicToNon|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
	
test bool publicToPrivate()
    = detection(
    	|java+method:///accessModifierClazzFieldAccessDecrease/Main/main(java.lang.String%5B%5D)|,
    	|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldPublicToPrivate|,
    	|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldPublicToPrivate|,
    	fieldAccess(),
    	fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
test bool protectedToNon()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecrease/Main/fieldProtectedToNon|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldProtectedToNon|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
   
test bool protectedToPrivate()
	= detection(
		|java+method:///accessModifierClazzFieldAccessDecrease/Main/main(java.lang.String%5B%5D)|,
		|java+field:///accessModifierClazzFieldAccessDecrease/Main/fieldProtectedToPrivate|,
		|java+field:///testing_lib/accessModifierClazzFieldAccessDecrease/AccessModifierClazzFieldAccessDecrease/fieldProtectedToPrivate|,
		fieldAccess(),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	in detects;
    
    