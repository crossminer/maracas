package mainclient.fieldNoLongerStatic;

import main.fieldNoLongerStatic.FieldNoLongerStatic;

public class FieldNoLongerStaticExt extends FieldNoLongerStatic {

	public int fieldNoLongerStaticClientNoSuperKey() {
		return fieldStatic;
	}
	
	public int fieldNoLongerStaticClientSuperKey() {
		return super.fieldStatic;
	}
}
