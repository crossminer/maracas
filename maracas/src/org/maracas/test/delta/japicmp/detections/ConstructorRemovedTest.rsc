module org::maracas::\test::delta::japicmp::detections::ConstructorRemovedTest

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
extend org::maracas::\test::delta::japicmp::detections::SetUp;


public test bool removedConstructorSimpleAccess()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedMI/constructorRemovedClientClass()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedClass/ConstructorRemovedClass()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorSimpleAccessParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedMI/constructorRemovedClientParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorSimpleAccessNoParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedMI/constructorRemovedClientNoParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorSuperConsParams()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedExtParams/ConstructorRemovedExtParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;

public test bool removedConstructorNoSuperConsParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedExtParams/constructorRemovedExtParamsNoSuper()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedParams/ConstructorRemovedParams(int)|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;
    
public test bool removedConstructorSuperConsNoParams()
	= detection(
		|java+constructor:///mainclient/constructorRemoved/ConstructorRemovedExtNoParams/ConstructorRemovedExtNoParams()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	in detects;

public test bool removedConstructorNoSuperConsNoParams()
	= detection(
		|java+method:///mainclient/constructorRemoved/ConstructorRemovedExtNoParams/constructorRemovedExtNoParamsNoSuper()|,
		|java+constructor:///main/constructorRemoved/ConstructorRemovedNoParams/ConstructorRemovedNoParams()|,
		methodInvocation(),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
    in detects;