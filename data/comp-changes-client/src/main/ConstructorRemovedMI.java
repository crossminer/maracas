package main;

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
