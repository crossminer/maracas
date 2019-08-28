package mainclient;

import java.util.ArrayList;

import main.MethodReturnTypeChanged;

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
