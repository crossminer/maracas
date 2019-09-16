module org::maracas::\test::delta::japicmp::detections::AllTests

extend org::maracas::\test::delta::japicmp::detections::ConstructorRemovedTest;
// Failing tests (3): simpleAccessNoAssign, superKeyAccessNoAssign, noSuperKeyAccessNoAssign
extend org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest;
extend org::maracas::\test::delta::japicmp::detections::FieldNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedInSuperclassTest;
// Failing tests (1): overrideTrans
extend org::maracas::\test::delta::japicmp::detections::MethodNowFinalTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedTest; 
// Failing tests (3): overrideSuperSSMethodExtSuper, overrideSuperSSMethodExtSSuper, overrideSuperSMethodExtSuper
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedInSuperclassTest;
extend org::maracas::\test::delta::japicmp::detections::ClassRemovedTest;
