package client;

import p2.Renamed1;
import p2.Renamed2;

public class Renamed {
	private Renamed1 classField;
	private Renamed2 methodField;
	
	public String classRenamed() {
		classField = new Renamed1("Existence", 1, true);
		return (classField.isF3()) ? classField.getF1() + classField.getF2() : "Perception";
	}
	
	public String methodRenamed() {
		methodField = new Renamed2();
		methodField.m1(new String[10]);
		return methodField.m2("Fix") + methodField.m3(new String[20]);
	}
}
