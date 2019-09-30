module org::maracas::\test::delta::japicmp::detections::ConstructorRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool simpleAccess()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedMI/constructorRemovedClientClass()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedClass/ConstructorRemovedClass()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedMI/constructorRemovedClientParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool simpleAccessNoParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedMI/constructorRemovedClientNoParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool anonymousAccess()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedMI$1/ConstructorRemovedMI$1(mainclient.constructorRemoved.ConstructorRemovedMI)|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedClass/ConstructorRemovedClass()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool anonymousAccessNoParams()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedMI$2/ConstructorRemovedMI$2(mainclient.constructorRemoved.ConstructorRemovedMI)|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool anonymousAccessParams()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedMI$3/ConstructorRemovedMI$3(mainclient.constructorRemoved.ConstructorRemovedMI,int)|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool superConsParams()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedExtParams/ConstructorRemovedExtParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool noSuperConsParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedExtParams/constructorRemovedExtParamsNoSuper()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool superConsNoParams()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedExtNoParams/ConstructorRemovedExtNoParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool noSuperConsNoParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedExtNoParams/constructorRemovedExtNoParamsNoSuper()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;