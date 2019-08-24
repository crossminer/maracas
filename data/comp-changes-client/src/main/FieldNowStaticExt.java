package main;

public class FieldNowStaticExt extends FieldNowStatic {

	public String fieldNowStaticClientSuperKeyAccess() {
		return super.MODIFIED_FIELD;
	}
	
	public String fieldNowStaticClientNoSuperKeyAccess() {
		return MODIFIED_FIELD;
	}
	
}
