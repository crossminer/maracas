package client;

import p2.Moved1;

public class Moved {
	public Moved1 classField;
	
	public String movedClass() {
		classField = new Moved1(true, 1, "Existence");
		int val = classField.getF3() + classField.getF4();
		return classField.getF5() + classField.getF6() + val;
	}
}
