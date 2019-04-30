package client;

import p1.ChangedFinalModifier1;
import p1.ChangedFinalModifier2;
import p1.ChangedFinalModifier3;

public class ChangedFinalModifier {
	
	private ChangedFinalModifier1 classField;
	private ChangedFinalModifier2 methodField;
	private ChangedFinalModifier3 fieldField;
	
	public int fieldChangedFinalModifier() {
		fieldField = new ChangedFinalModifier3();
		return fieldField.field1 + fieldField.field2;
	}
	
	public void methodChangedFinalModifier() {
		methodField = new ChangedFinalModifier2();
		methodField.m1();
		methodField.m4();
		methodField.m2();
		methodField.m5();
	}
	
	public void classChangedFinalModifier() {
		classField = new ChangedFinalModifier1();
	}
}
