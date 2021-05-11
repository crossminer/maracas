package mainclient.methodNowAbstract;

import main.methodNowAbstract.IMethodNowAbastract;

public class MethodNowAbstractImp implements IMethodNowAbastract {

	@Override
	public int methodStayAbstract() {
		return 0;
	}

	public int methodNowAbstractClient() {
		return IMethodNowAbastract.methodNowAbstract();
	}

}
