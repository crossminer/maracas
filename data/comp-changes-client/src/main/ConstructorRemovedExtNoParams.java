package main;

public class ConstructorRemovedExtNoParams extends ConstructorRemovedNoParams {

	public ConstructorRemovedExtNoParams() {
		super();
	}
	
	public void constructorRemovedExtNoParamsNoSuper() {
		ConstructorRemovedExtNoParams c = (ConstructorRemovedExtNoParams) new ConstructorRemovedNoParams();
	}
}
