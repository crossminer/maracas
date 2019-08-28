package mainclient;

import main.FieldNowStatic;

public class FieldNowStaticFA {

	public String fieldNowStaticClientSimpleAccess() {
		FieldNowStatic f = new FieldNowStatic();
		return f.MODIFIED_FIELD;
	}
}
