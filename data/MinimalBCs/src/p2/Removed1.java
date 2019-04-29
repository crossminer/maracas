package p2;

import java.util.ArrayList;
import java.util.List;

public class Removed1 {
	private List<String> f1;
	public boolean f2;
	public boolean f3;
	public int f4;
	public int f5;
	
	public Removed1(boolean f2, boolean f3, int f4, int f5) {
		super();
		this.f2 = f2;
		this.f3 = f3;
		this.f4 = f4;
		this.f5 = f5;
		this.f1 = new ArrayList<String>();
	}

	
	public boolean isF2() {
		return f2 || f3;
	}


	public void setF2(boolean f2) {
		this.f2 = f2;
	}


	public boolean isF3() {
		return f3 && f2;
	}


	public void setF3(boolean f3) {
		this.f3 = f3;
	}


	public int getF4() {
		return f4 + f5;
	}


	public void setF4(int f4) {
		this.f4 = f4;
	}


	public int getF5() {
		return f5 - f4;
	}


	public void setF5(int f5) {
		this.f5 = f5;
	}


	@Override
	public String toString() {
		return "Removed1 [f1=" + f1 + ", f2=" + f2 + ", f3=" + f3 + ", f4=" + f4 + ", f5=" + f5 + "]";
	}
	
}
