package p1;

public class B {

	// [REFACT] Removing method m1().
	
	// [REFACT] Modifying parameter list m2().
	public void m2(int i) {
		
	}
	
	// [REFACT] Modifying return type m3().
	public int m3() {
		return 1;
	}
	
	// [REFACT] Modifying access modifier m4().
	private void m4() {
		
	}
	
	// [REFACT] Renaming method m5() -> m6().
	public int m6() {
		System.out.println("Hello, lets see if we can identify this snippet.");
		int eternity = 42;
		return eternity;
	}
	
	public void m7() {
		
	}
	
	public static final void m8() {
		
	}
}
