package main;

public class MethodLessAccessibleMI {

	MethodLessAccessible m;
	
	public MethodLessAccessibleMI() {
		m = new MethodLessAccessible();
	}
	
	public int methodLessAccessiblePub2ProClientSimpleAccess() {
		return m.methodLessAccessiblePublic2Protected();
	}
	
	public int methodLessAccessiblePub2PackPrivClientSimpleAccess() {
		return m.methodLessAccessiblePublic2PackPriv();
	}
	
	public int methodLessAccessiblePub2PrivClientSimpleAccess() {
		return m.methodLessAccessiblePublic2Private();
	}
	
	public int methodLessAccessiblePro2PubClientSimpleAccess() {
		return m.methodLessAccessibleProtected2Public();
	}
	
	public int methodLessAccessiblePro2PackPrivClientSimpleAccess() {
		return m.methodLessAccessibleProtected2PackPriv();
	}
	
	public int methodLessAccessiblePro2PrivClientSimpleAccess() {
		return m.methodLessAccessibleProtected2Private();
	}
	
	public int methodLessAccessiblePackPriv2PubClientSimpleAccess() {
		return m.methodLessAccessiblePackPriv2Public();
	}
	
	public int methodLessAccessiblePackPriv2ProClientSimpleAccess() {
		return m.methodLessAccessiblePackPriv2Protected();
	}
	
	public int methodLessAccessiblePackPriv2PrivClientSimpleAccess() {
		return m.methodLessAccessiblePackPriv2Private();
	}
}
