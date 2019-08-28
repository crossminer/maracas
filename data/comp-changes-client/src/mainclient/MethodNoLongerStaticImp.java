package mainclient;

import main.IMethodNoLongerStatic;

public class MethodNoLongerStaticImp implements IMethodNoLongerStatic {
	
	public int methodNoLongerStaticClient() {
		return IMethodNoLongerStatic.methodNoLongerStatic();
	}
}
