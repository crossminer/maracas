package mainclient.constructorRemoved;

import main.constructorRemoved.ConstructorRemovedNoParams;

/**
 * Reactions:
 * 1) Adding parameter to constructor
 * 2) invokinng constructor with parameter
 * 3) Creating variable i = 0 
 * 4) Creatinng object with parameter i
 *  
 * @author Lina Ochoa
 *
 */
public class ConstructorRemovedExtNoParams extends ConstructorRemovedNoParams {

	public ConstructorRemovedExtNoParams(int param) {
		super(param);
	}
	
	public void constructorRemovedExtNoParamsNoSuper() {
	    int i = 0;
		ConstructorRemovedExtNoParams c = (ConstructorRemovedExtNoParams) new ConstructorRemovedNoParams(i);
	}
}
