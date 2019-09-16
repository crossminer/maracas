module org::maracas::\test::delta::japicmp::detections::AllTests

extend org::maracas::\test::delta::japicmp::detections::ConstructorRemovedTest;
// Tests: simpleAccessNoAssign, superKeyAccessNoAssign, noSuperKeyAccessNoAssign
extend org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest; // Failing: 3 noAssign
extend org::maracas::\test::delta::japicmp::detections::FieldNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedInSuperclassTest;
// Tests: overridesTrans
extend org::maracas::\test::delta::japicmp::detections::MethodNowFinalTest; // Failing: 1 methodOverrides 
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedTest; 
// Tests: overrideSuperSSMethodExtSuper, overrideSuperSSMethodExtSSuper, overrideSuperSMethodExtSuper
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedInSuperclassTest; // Failing: 3 methodOverrides
extend org::maracas::\test::delta::japicmp::detections::ClassRemovedTest;
