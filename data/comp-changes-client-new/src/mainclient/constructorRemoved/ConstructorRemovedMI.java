package mainclient.constructorRemoved;

import main.constructorRemoved.ConstructorRemovedNoParams;
import main.constructorRemoved.ConstructorRemovedParams;

/**
 * Reactions:
 * 1) Removing parameters from ConstructorRemovedParams()
 * 2) Adding parameter to ConstructorRemovedNoParams(0)
 * 3) Removing ConstructorRemovedClass() uses
 * 4) Removing ConstructorRemovedClass import
 * 
 * @author Lina Ochoa
 *
 */
public class ConstructorRemovedMI {

	public void constructorRemovedClientClass() {
	    
	}

	public void constructorRemovedClientNoParams() {
		ConstructorRemovedNoParams c = new ConstructorRemovedNoParams(0);
	}

	public void constructorRemovedClientParams() {
		ConstructorRemovedParams c = new ConstructorRemovedParams();
	}

	public void constructorRemovedClientClassAnonymous() {
		
	}

	public void constructorRemovedClientNoParamsAnonymous() {
		ConstructorRemovedNoParams c = new ConstructorRemovedNoParams(0) {};
	}

	public void constructorRemovedClientParamsAnonymous() {
		ConstructorRemovedParams c = new ConstructorRemovedParams() {};
	}
}
