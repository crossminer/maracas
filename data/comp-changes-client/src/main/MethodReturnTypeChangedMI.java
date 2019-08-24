package main;

import java.util.ArrayList;

public class MethodReturnTypeChangedMI {

	public long methodReturnTypeChangedNumericClient() {
		MethodReturnTypeChanged m = new MethodReturnTypeChanged();
		return m.methodReturnTypeChangedNumeric();
	}
	
	public ArrayList methodReturnTypeChangedListClient() {
		MethodReturnTypeChanged m = new MethodReturnTypeChanged();
		return m.methodReturnTypeChangedList();
	}
	
}
