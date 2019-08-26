package main;

public class FieldNoLongerStaticExt extends FieldNoLongerStatic {

	public int fieldNoLongerStaticClientNoSuperKey() {
		return fieldStatic;
	}
	
	public int fieldNoLongerStaticClientSuperKey() {
		return super.fieldStatic;
	}
}
