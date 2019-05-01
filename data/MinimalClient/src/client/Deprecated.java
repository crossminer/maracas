package client;

import java.util.ArrayList;

import p2.Deprecated1;
import p2.Deprecated2;
import p2.Deprecated3;

public class Deprecated {
	public Deprecated1 classField;
	private Deprecated2 methodField;
	private Deprecated3 fieldField;
	
	private Deprecated1 classDeprecated() {
		classField = new Deprecated1();
		return classField;
	}
	
	public String methodDeprecated() {
		methodField = new Deprecated2();
		methodField.m1();
		methodField.m2();
		return methodField.m3();
	}
	
	public void fieldDeprecated() {
		fieldField = new Deprecated3();
		String[] a = fieldField.field1;
		String b = fieldField.field2;
		byte[][] c = fieldField.field3;
		fieldField.field4 = new ArrayList<Integer>();
	}
}
