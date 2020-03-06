module org::maracas::\test::delta::japicmp::delta::FilterTestsTest

import List;
import Map;

import org::maracas::delta::JApiCmp;
import org::maracas::\test::delta::japicmp::delta::JApiCmpResults;
import org::maracas::\test::delta::japicmp::SetUp;


private bool isInDelta(loc elem) {
	try {
		entityFromLoc(elem, delta);
		return true;
	}
	catch e:
		return false;
}

test bool noChangesTestPkg1()
	= !isInDelta(|java+class:///main/test/classRemoved/ClassRemoved|)
	&& !isInDelta(|java+class:///main/test/methodRemoved/MethodRemoved|);

test bool noChangesTestPkg2() 
	= !isInDelta(|java+class:///test/classRemoved/ClassRemoved|)
	&& !isInDelta(|java+class:///test/methodRemoved/MethodRemoved|);

test bool noChangesTestsPkg() 
	= !isInDelta(|java+class:///main/tests/classRemoved/ClassRemoved|)
	&& !isInDelta(|java+class:///main/tests/methodRemoved/MethodRemoved|);

test bool noChangesJUnitTest()
	= !isInDelta(|java+method:///main/junitT3st/methodRemoved/MethodRemoved/methodTest()|);

test bool noChangesJUnitAfter()
	= !isInDelta(|java+method:///main/junitT3st/methodRemoved/MethodRemoved/methodAfter()|);

test bool noChangesJUnitAfterClass()
	= !isInDelta(|java+method:///main/junitT3st/methodRemoved/MethodRemoved/methodAfterClass()|);

test bool noChangesJUnitBefore()
	= !isInDelta(|java+method:///main/junitT3st/methodRemoved/MethodRemoved/methodBefore()|);

test bool noChangesJUnitBeforeClass()
	= !isInDelta(|java+method:///main/junitT3st/methodRemoved/MethodRemoved/methodBeforeClass()|);

test bool noChangesJUnitIgnore()
	= !isInDelta(|java+method:///main/junitT3st/methodRemoved/MethodRemoved/methodIgnore()|);

test bool noChangesJUnitRunWith()
	= !isInDelta(|java+class:///main/junitT3st/classRemoved/ClassRemovedSuite|);