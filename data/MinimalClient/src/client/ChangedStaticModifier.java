package client;

import p1.ChangedStaticModifier2;
import p1.ChangedStaticModifier3;

public class ChangedStaticModifier {
	
	private ChangedStaticModifier2 methodField;
	private ChangedStaticModifier3 fieldField;
	
	public void fieldChangedStaticModifier() {
		fieldField = new ChangedStaticModifier3();
		int sum = ChangedStaticModifier3.field1 + fieldField.field2;
		String c = ChangedStaticModifier3.field3;
		fieldField.field4 = "b";
	}
	
	public void methodChangedStaticModifier() {
		methodField = new ChangedStaticModifier2();
		methodField.m1();
		ChangedStaticModifier2.m2();
		methodField.m5();
	}
}
