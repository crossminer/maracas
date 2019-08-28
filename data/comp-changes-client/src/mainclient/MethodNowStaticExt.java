package mainclient;

import main.MethodNowStatic;

public class MethodNowStaticExt extends MethodNowStatic {

	public int methodNowStaticClientSuperKeyAccess() {
		return super.methodNowStatic();
	}
	
	public int methodNowStaticClientNoSuperKeyAccess() {
		return methodNowStatic();
	}
}
