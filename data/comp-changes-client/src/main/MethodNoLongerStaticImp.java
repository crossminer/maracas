package main;

public class MethodNoLongerStaticImp implements IMethodNoLongerStatic {
	
	public int methodNoLongerStaticClient() {
		return IMethodNoLongerStatic.methodNoLongerStatic();
	}
}
