package client;

import p1.ChangedAbstractModifier1;
import p1.ChangedAbstractModifier2;
import p1.ChangedAbstractModifier3;

public class ChangedAbstractModifier {

	private ChangedAbstractModifier1 classField1;
	private ChangedAbstractModifier2 methodField;
	private ChangedAbstractModifier3 classField2;
	
	public void classChangedAccessModifier1() {
		classField1 = new ChangedAbstractModifier1();
	}
	
	public void classChangedAccessModifier2() {
		classField2 = new ChangedAbstractModifier3();
		int i = classField2.f1;
		classField2.m1();
		classField2.m2();
	}
	
	public void methodChangedAccessModifier() {
		methodField.m1();
		methodField.m2();
	}
}
