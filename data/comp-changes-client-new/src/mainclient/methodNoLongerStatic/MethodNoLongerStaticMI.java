package mainclient.methodNoLongerStatic;

import main.methodNoLongerStatic.MethodNoLongerStatic;

/**
 * Reactions:
 * - Instantiating object methodNoLongerStaticClientClass()
 * - Change static to object access
 * @author Lina Ochoa
 *
 */
public class MethodNoLongerStaticMI {

	public int methodNoLongerStaticClientClass() {
	    MethodNoLongerStatic m = new MethodNoLongerStatic();
		return m.methodNoLongerStatic();
	}
	
	public int methodNoLongerStaticClientObject() {
		MethodNoLongerStatic m = new MethodNoLongerStatic();
		return m.methodNoLongerStatic();
	}
	
}
