package p2;

import java.util.Arrays;

public class Removed2 {

	private int [][] f1;
	private String [][] f2;
	public int f3;
	public String f4;
	
	public Removed2(int f3, String f4) {
		super();
		this.f3 = f3;
		this.f4 = f4;
		this.f1 = new int [this.f3][this.f3];
		this.f2 = new String [this.f3][this.f3];
		populateMatrices();
	}
	
	private void populateMatrices() {
		for (int i = 0; i < f3; i++) {
			for (int j = 0; j < f3; j++) {
				f1[i][j] = i + j;
			}
		}
		
		for (int i = 0; i < f3; i++) {
			for (int j = 0; j < f3; j++) {
				f2[i][j] = f4 + (i % j);
			}
		}
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
	
	public int[][] getF1() {
		return f1;
	}

	public void setF1(int[][] f1) {
		this.f1 = f1;
	}

	public String[][] getF2() {
		return f2;
	}

	public void setF2(String[][] f2) {
		this.f2 = f2;
	}

	@Override
	public String toString() {
		return "Removed2 [f1=" + Arrays.toString(f1) + ", f2=" + Arrays.toString(f2) + ", f3=" + f3 + ", f4=" + f4
				+ "]";
	}
}
