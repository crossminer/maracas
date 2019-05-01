package client;

import p2.Removed1;
import p2.Removed2;

public class Removed {
	private Removed1 classField;
	private Removed2 methodField;
	
	public int classRemoved() {
		classField = new Removed1(false, true, 0, 1);
		return classField.getF4() + classField.getF5();
	}
	
	public void methodRemoved() {
		methodField = new Removed2(11, "11");
		methodField.getF1();
		methodField.getF2();
		methodField.getF3();
		methodField.getF4();
		methodField.populateMatrices();
	}
}
