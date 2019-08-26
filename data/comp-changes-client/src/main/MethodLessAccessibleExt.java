package main;

public class MethodLessAccessibleExt extends MethodLessAccessible {

	@Override
	public int methodLessAccessiblePublic2Protected() {
		return 100;
	}
	
	@Override
	public int methodLessAccessiblePublic2PackPriv() {
		return 101;
	}
	
	@Override
	public int methodLessAccessiblePublic2Private() {
		return 102;
	}
	
	@Override
	protected int methodLessAccessibleProtected2Public() {
		return 103;
	}
	
	@Override
	protected int methodLessAccessibleProtected2PackPriv() {
		return 104;
	}
	
	@Override
	protected int methodLessAccessibleProtected2Private() {
		return 105;
	}
	
	@Override
	int methodLessAccessiblePackPriv2Public() {
		return 106;
	}
	
	@Override
	int methodLessAccessiblePackPriv2Protected() {
		return 107;
	}
	
	@Override
	int methodLessAccessiblePackPriv2Private() {
		return 108;
	}

}
