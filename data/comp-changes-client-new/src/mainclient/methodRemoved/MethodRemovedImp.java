package mainclient.methodRemoved;

import main.methodRemoved.IMethodRemoved;

/**
 * Reactions:
 * 1) Create local solution (i.e. IMethodRemovedClient)
 * 2) Extend implements
 * @author Lina Ochoa
 *
 */
public class MethodRemovedImp implements IMethodRemoved, IMethodRemovedClient {

	@Override
	public int methodRemoved() {
		return 0;
	}

	@Override
	public int methodStay() {
		return 1;
	}

}
