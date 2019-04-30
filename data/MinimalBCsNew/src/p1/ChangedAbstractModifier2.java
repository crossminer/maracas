package p1;

public abstract class ChangedAbstractModifier2 {

	public int m1() {
		return m5();
	}
	
	public abstract String m2();
	
	protected void m3() {
		
	}
	
	public abstract void m4();
	
	private int m5() {
		return 42;
	}
	
	protected abstract String m6();
}
