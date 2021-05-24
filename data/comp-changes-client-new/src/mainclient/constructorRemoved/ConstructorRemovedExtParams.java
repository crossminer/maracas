package mainclient.constructorRemoved;

import main.constructorRemoved.ConstructorRemovedParams;

/**
 * Reactions:
 * 1) Removing parameter from super invocation
 * 2) Removing parameter from object creation
 * 
 * @author Lina Ochoa
 *
 */
public class ConstructorRemovedExtParams extends ConstructorRemovedParams {

	public ConstructorRemovedExtParams() {
		super();
	}
	
	public void constructorRemovedExtParamsNoSuper() {
		ConstructorRemovedExtParams c = (ConstructorRemovedExtParams) new ConstructorRemovedParams();
	}
}
