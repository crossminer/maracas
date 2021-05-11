package mainclient.methodRemoved;

/**
 * Reactions:
 * 1) Create local solution (i.e. MethodRemovedClient)
 * 2) Change extends
 * 3) Remove imports
 * @author Lina Ochoa
 *
 */
public class MethodRemovedExt extends MethodRemovedClient {

	public int methodRemovedClientExt() {
		return methodRemoved();
	}
	
	public int methodRemovedClientSuper() {
		return super.methodRemoved();
	}
}
