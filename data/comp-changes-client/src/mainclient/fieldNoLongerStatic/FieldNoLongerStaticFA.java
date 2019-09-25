package mainclient.fieldNoLongerStatic;

import main.fieldNoLongerStatic.FieldNoLongerStatic;
import main.fieldNoLongerStatic.FieldNoLongerStaticSuper;

public class FieldNoLongerStaticFA {

	public int fieldNoLongerStaticClient() {
		return FieldNoLongerStatic.fieldStatic;
	}
	
	public int fieldNoLongerStaticSuperClient1() {
		return FieldNoLongerStatic.superFieldStatic;
	}

	public int fieldNoLongerStaticSuperClient2() {
		return FieldNoLongerStaticSuper.superFieldStatic;
	}
}
