package p2;

public class Renamed1 {

	public String f1;
	public int f2;
	private boolean f3;
	
	public Renamed1(String f1, int f2, boolean f3) {
		this.f1 = f1;
		this.f2 = f2;
		this.f3 = f3;
	}
	
	public String getF1() {
		return "Hello" + f1;
	}

	public void setF1(String f1) {
		this.f1 = f1;
	}

	public int getF2() {
		return 100 + f2;
	}

	public void setF2(int f2) {
		this.f2 = f2;
	}

	public boolean isF3() {
		return !f3;
	}

	public void setF3(boolean f3) {
		this.f3 = f3;
	}
}
