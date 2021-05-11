package mainclient.constructorRemoved;

import main.constructorRemoved.ConstructorRemovedClass;
import main.constructorRemoved.ConstructorRemovedNoParams;
import main.constructorRemoved.ConstructorRemovedParams;

public class ConstructorRemovedMI {

	public void constructorRemovedClientClass() {
		ConstructorRemovedClass c = new ConstructorRemovedClass();
	}

	public void constructorRemovedClientNoParams() {
		ConstructorRemovedNoParams c = new ConstructorRemovedNoParams();
	}

	public void constructorRemovedClientParams() {
		ConstructorRemovedParams c = new ConstructorRemovedParams(0);
	}

	public void constructorRemovedClientClassAnonymous() {
		ConstructorRemovedClass c = new ConstructorRemovedClass() {};
	}

	public void constructorRemovedClientNoParamsAnonymous() {
		ConstructorRemovedNoParams c = new ConstructorRemovedNoParams() {};
	}

	public void constructorRemovedClientParamsAnonymous() {
		ConstructorRemovedParams c = new ConstructorRemovedParams(0) {};
	}
}
