module org::maracas::\test::delta::japicmp::detections::AllTests

extend org::maracas::\test::delta::japicmp::detections::AnnotationDeprecatedAddedTest;
extend org::maracas::\test::delta::japicmp::detections::ConstructorLessAccessibleTest;
extend org::maracas::\test::delta::japicmp::detections::ConstructorRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::FieldLessAccessibleTest;
extend org::maracas::\test::delta::japicmp::detections::FieldNoLongerStaticTest; // Failing tests (1): superKeyAccess
extend org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest; // Failing tests (3): simpleAccessNoAssign, superKeyAccessNoAssign, noSuperKeyAccessNoAssign
extend org::maracas::\test::delta::japicmp::detections::FieldNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedInSuperclassTest;
extend org::maracas::\test::delta::japicmp::detections::FieldTypeChangedTest; // Failing tests (3): listNoSuperKeyAccess, listSimpleAccess, listSuperKeyAccess
extend org::maracas::\test::delta::japicmp::detections::MethodAbstractAddedInSuperclassTest;
extend org::maracas::\test::delta::japicmp::detections::MethodAbstractAddedToClassTest;
extend org::maracas::\test::delta::japicmp::detections::MethodAbstractNowDefaultTest;
extend org::maracas::\test::delta::japicmp::detections::MethodAddedToInterfaceTest;
extend org::maracas::\test::delta::japicmp::detections::MethodLessAccessibleTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNewDefaultTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNoLongerStaticTest; // Failing tests (2): superKeyAccess, simpleAccessObj
extend org::maracas::\test::delta::japicmp::detections::MethodNowAbstractTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNowFinalTest; // Failing tests (1): overrideTrans
extend org::maracas::\test::delta::japicmp::detections::MethodNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedTest; 
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedInSuperclassTest; // Failing tests (3): overrideSuperSSMethodExtSuper, overrideSuperSSMethodExtSSuper, overrideSuperSMethodExtSuper
extend org::maracas::\test::delta::japicmp::detections::MethodReturnTypeChangedTest; // Failing tests (4): superKeyNumeric, noSuperKeyNumeric, overrideList, simpleAccessNumeric
extend org::maracas::\test::delta::japicmp::detections::ClassLessAccessibleTest; // Failing tests (2): packpriv2privExt, packpriv2privExt
extend org::maracas::\test::delta::japicmp::detections::ClassNoLongerPublicTest; // Failing tests (1): impInterface
extend org::maracas::\test::delta::japicmp::detections::ClassNowCheckedExceptionTest;
extend org::maracas::\test::delta::japicmp::detections::ClassNowAbstractTest; // Failing tests (2): createObjectParams, createObject 
extend org::maracas::\test::delta::japicmp::detections::ClassRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::ClassTypeChangedTest;
extend org::maracas::\test::delta::japicmp::detections::ClassNowFinalTest;
