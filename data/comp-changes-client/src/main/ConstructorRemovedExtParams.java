package main;

public class ConstructorRemovedExtParams extends ConstructorRemovedParams {

	public ConstructorRemovedExtParams() {
		super(0);
	}
	
	public void constructorRemovedExtParamsNoSuper() {
		ConstructorRemovedExtParams c = (ConstructorRemovedExtParams) new ConstructorRemovedParams(0);
	}
}
