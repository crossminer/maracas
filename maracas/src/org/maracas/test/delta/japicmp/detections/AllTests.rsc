module org::maracas::\test::delta::japicmp::detections::AllTests

extend org::maracas::\test::delta::japicmp::detections::FieldLessAccessibleTest;
extend org::maracas::\test::delta::japicmp::detections::FieldNoLongerStaticTest; // Failing tests (2): superKeyAccess, simpleAccessSuper1
extend org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest; // Failing tests (6): simpleAccessNoAssign(Sub), superKeyAccessNoAssign(Sub), noSuperKeyAccessNoAssign(Sub)
extend org::maracas::\test::delta::japicmp::detections::FieldNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::FieldTypeChangedTest; // Failing tests (6): listNoSuperKeyAccess(Sub), listSimpleAccess(Sub), listSuperKeyAccess(Sub)
extend org::maracas::\test::delta::japicmp::detections::MethodAbstractAddedToClassTest;
extend org::maracas::\test::delta::japicmp::detections::MethodAbstractNowDefaultTest;
extend org::maracas::\test::delta::japicmp::detections::MethodAddedToInterfaceTest;
extend org::maracas::\test::delta::japicmp::detections::MethodLessAccessibleTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNewDefaultTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNoLongerStaticTest; // Failing tests (2): superKeyAccess, simpleAccessObj
extend org::maracas::\test::delta::japicmp::detections::MethodNowAbstractTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNowFinalTest; // Failing tests (1): overrideTrans
extend org::maracas::\test::delta::japicmp::detections::MethodNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::MethodNowThrowsCheckedExceptionTest;
extend org::maracas::\test::delta::japicmp::detections::MethodRemovedTest; 
extend org::maracas::\test::delta::japicmp::detections::MethodReturnTypeChangedTest; // Failing tests (4): superKeyNumeric, noSuperKeyNumeric, overrideList, simpleAccessNumeric
extend org::maracas::\test::delta::japicmp::detections::ConstructorLessAccessibleTest; // Failing tests (1): anonymousConstructorAccess
extend org::maracas::\test::delta::japicmp::detections::ConstructorRemovedTest;
