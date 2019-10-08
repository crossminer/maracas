module org::maracas::\test::delta::japicmp::detections::AllTests

extend org::maracas::\test::delta::japicmp::detections::FieldLessAccessibleTest;
extend org::maracas::\test::delta::japicmp::detections::FieldNoLongerStaticTest; // Failing tests (2): superKeyAccess, simpleAccessSuper1
extend org::maracas::\test::delta::japicmp::detections::FieldNowFinalTest; // Failing tests (6): simpleAccessNoAssign(Sub), superKeyAccessNoAssign(Sub), noSuperKeyAccessNoAssign(Sub)
extend org::maracas::\test::delta::japicmp::detections::FieldNowStaticTest;
extend org::maracas::\test::delta::japicmp::detections::FieldRemovedTest;
extend org::maracas::\test::delta::japicmp::detections::FieldTypeChangedTest; // Failing tests (6): listNoSuperKeyAccess(Sub), listSimpleAccess(Sub), listSuperKeyAccess(Sub)
