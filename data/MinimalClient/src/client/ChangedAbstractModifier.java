package client;

import p1.ChangedAbstractModifier1;
import p1.ChangedAbstractModifier2;

public class ChangedAbstractModifier {

	private ChangedAbstractModifier1 classField;
	private ChangedAbstractModifier2 methodField;
	
	public void classChangedAccessModifier() {
		classField = new ChangedAbstractModifier1();
	}
	
	public void methodChangedAccessModifier() {
		methodField.m1();
		methodField.m2();
	}
}
