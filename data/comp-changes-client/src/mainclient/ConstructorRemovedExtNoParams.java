package mainclient;

import main.ConstructorRemovedNoParams;

public class ConstructorRemovedExtNoParams extends ConstructorRemovedNoParams {

	public ConstructorRemovedExtNoParams() {
		super();
	}
	
	public void constructorRemovedExtNoParamsNoSuper() {
		ConstructorRemovedExtNoParams c = (ConstructorRemovedExtNoParams) new ConstructorRemovedNoParams();
	}
}
