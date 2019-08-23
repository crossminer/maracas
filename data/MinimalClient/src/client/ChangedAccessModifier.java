package client;

import p1.ChangedAccessModifier2;
import p1.ChangedAccessModifier3;
import p1.ChangedAccessModifier4;

public class ChangedAccessModifier {
	
	private ChangedAccessModifier2 f1;
	private ChangedAccessModifier3 f2;
	private ChangedAccessModifier4 f3;
	
	public void methodChangedAccessModifier() {
		f1 = new ChangedAccessModifier2();
		f1.m1();
		f1.m4();
	}
	
	public String fieldChangedAccessModifier() {
		f2 = new ChangedAccessModifier3();
		String s1 = f2.field3;
		String s2 = f2.field6;
		return s1 + s2;
	}
	
	public void classChangedAccessModifier(ChangedAccessModifier4 c) {
		f3 = c;
		f3.m1();
		f3.m3();
	}
}
