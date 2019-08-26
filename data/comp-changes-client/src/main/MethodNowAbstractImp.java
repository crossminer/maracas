package main;

public class MethodNowAbstractImp implements IMethodNowAbastract {

	@Override
	public int methodStayAbstract() {
		return 0;
	}

	public int methodNowAbstractClient() {
		return IMethodNowAbastract.methodNowAbstract();
	}

}
