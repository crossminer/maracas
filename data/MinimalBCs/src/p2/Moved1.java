package p2;

import java.util.ArrayList;
import java.util.List;

public class Moved1 {
	
	private boolean f1;
	public boolean f2;
	private int f3;
	public int f4;
	private String f5;
	public String f6;
	
	public Moved1(boolean f1, int f3, String f5) {
		super();
		this.f1 = f1;
		this.f3 = f3;
		this.f5 = f5;
	}

	public boolean isF1() {
		return f1;
	}
	
	public void setF1(boolean f1) {
		this.f1 = f1;
	}
	
	public boolean isF2() {
		return f2;
	}
	
	public void setF2(boolean f2) {
		this.f2 = f2;
	}
	
	public int getF3() {
		return f3;
	}
	
	public void setF3(int f3) {
		this.f3 = f3;
	}
	
	public int getF4() {
		return f4;
	}
	
	public void setF4(int f4) {
		this.f4 = f4;
	}
	
	public String getF5() {
		return f5;
	}
	
	public void setF5(String f5) {
		this.f5 = f5;
	}
	
	public String getF6() {
		return f6;
	}
	
	public void setF6(String f6) {
		this.f6 = f6;
	}
	
	public String m1() {
		return "Hellooooo " + f5 + f6;
	}
	
	public int m2() {
		return (f3 + f4) % 2;
	}
	
	public boolean m3() {
		return f1 || f2;
	}
	
	public List<String> m4() {
		String myString = f5 + f6;
		List<String> myList = new ArrayList<String>();
		System.out.println(myString);
		
		if(m3()) {
			for(int i = 0; i < myString.length(); i++) {
				myList.add("Char #" + i + ": " + myString.charAt(i));
			}
		}
		
		return myList;
	}
}
