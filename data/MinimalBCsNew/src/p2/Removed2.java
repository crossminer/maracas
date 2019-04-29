package p2;

public class Removed2 {

	public int f3;
	public String f4;
	
	public Removed2(int f3, String f4) {
		super();
		this.f3 = f3;
		this.f4 = f4;
	}

	public int getF3() {
		return f3;
	}

	public void setF3(int f3) {
		this.f3 = f3;
	}

	public String getF4() {
		return f4;
	}

	public void setF4(String f4) {
		this.f4 = f4;
	}


	@Override
	public String toString() {
		return "Removed2 [f1=" + ", f3=" + f3 + ", f4=" + f4
				+ "]";
	}
}
