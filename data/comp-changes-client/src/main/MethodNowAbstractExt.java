package main;

public class MethodNowAbstractExt extends MethodNowAbstract {

	@Override
	public int methodStayAbstract() {
		return 0;
	}

	public int methodNowAbstractClientSuperKey() {
		return super.methodNowAbstract();
	}
	
	public int methodNowAbstractClientNoSuperKey() {
		return methodNowAbstract();
	}
}
