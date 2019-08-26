package main;

public class MethodNoLongerStaticMI {

	public int methodNoLongerStaticClientClass() {
		return MethodNoLongerStatic.methodNoLongerStatic();
	}
	
	public int methodNoLongerStaticClientObject() {
		MethodNoLongerStatic m = new MethodNoLongerStatic();
		return m.methodNoLongerStatic();
	}
	
}
