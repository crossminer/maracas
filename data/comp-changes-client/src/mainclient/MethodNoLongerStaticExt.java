package mainclient;

import main.MethodNoLongerStatic;

public class MethodNoLongerStaticExt extends MethodNoLongerStatic {

	public int methodNoLongerStaticSuperKeyAccess() {
		return super.methodNoLongerStatic();
	}
	
	public int methodNoLongerStaticNoSuperKeyAccess() {
		return methodNoLongerStatic();
	}
}
