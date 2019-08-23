package main;

public class MethodRemovedExt extends MethodRemoved {

	public int methodRemovedClientExt() {
		return methodRemoved();
	}
	
	public int methodRemovedClientSuper() {
		return super.methodRemoved();
	}
}
