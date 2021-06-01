package mainclient.methodNowAbstract;

import main.methodNowAbstract.MethodNowAbstract;

/**
 * Reactions:
 * - Add unimplemented methodNowAbstract()
 * - Remove super invocation methodNowAbstractClientSuperKey()
 * - Add local invocation methodNowAbstractClientSuperKey()
 * @author Lina Ochoa
 *
 */
public class MethodNowAbstractExt extends MethodNowAbstract {

	@Override
	public int methodStayAbstract() {
		return 0;
	}

	public int methodNowAbstractClientSuperKey() {
		return methodNowAbstract();
	}
	
	public int methodNowAbstractClientNoSuperKey() {
		return methodNowAbstract();
	}

    @Override
    public int methodNowAbstract() {
        return 0;
    }
}
