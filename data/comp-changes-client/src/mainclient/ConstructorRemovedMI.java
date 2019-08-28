package mainclient;

import main.ConstructorRemovedClass;
import main.ConstructorRemovedNoParams;
import main.ConstructorRemovedParams;

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
}
