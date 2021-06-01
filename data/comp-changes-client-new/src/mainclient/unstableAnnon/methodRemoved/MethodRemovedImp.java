package mainclient.unstableAnnon.methodRemoved;

import main.unstableAnnon.methodRemoved.IMethodRemoved;

/**
 * Reactions:
 * - Remove @Override from methodRemoved()
 * @author Lina Ochoa
 *
 */
public class MethodRemovedImp implements IMethodRemoved {

	public int methodRemoved() {
		return 0;
	}

	@Override
	public int methodStay() {
		return 1;
	}

}
