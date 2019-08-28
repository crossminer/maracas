package mainclient;

import java.util.ArrayList;

import main.MethodReturnTypeChanged;

public class MethodReturnTypeChangedExt extends MethodReturnTypeChanged {

	public long methodReturnTypeChangedNumericClientSuperKey() {
		return super.methodReturnTypeChangedNumeric();
	}
	
	public ArrayList methodReturnTypeChangedListClientSuperKey() {
		return super.methodReturnTypeChangedList();
	}
	
	public long methodReturnTypeChangedNumericClientNoSuperKey() {
		return methodReturnTypeChangedNumeric();
	}
	
	public ArrayList methodReturnTypeChangedListClientNoSuperKey() {
		return methodReturnTypeChangedList();
	}
}
