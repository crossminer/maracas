package main;

public class FieldLessAccessibleFASubtype extends FieldLessAccessible {

	public int fieldLessAccessibleClientPub2ProNoSuperKey() {
		return public2protected;
	}
	
	public int fieldLessAccessibleClientPub2PackPrivNoSuperKey() {
		return public2packageprivate;
	}
	
	public int fieldLessAccessibleClientPub2PrivNoSuperKey() {
		return public2private;
	}
	
	public int fieldLessAccessibleClientPro2PackPrivNoSuperKey() {
		return protected2packageprivate;
	}
	
	public int fieldLessAccessibleClientPro2PrivNoSuperKey() {
		return protected2private;
	}
	
	public int fieldLessAccessibleClientPub2ProSuperKey() {
		return super.public2protected;
	}
	
	public int fieldLessAccessibleClientPub2PackPrivSuperKey() {
		return super.public2packageprivate;
	}
	
	public int fieldLessAccessibleClientPub2PrivSuperKey() {
		return super.public2private;
	}
	
	public int fieldLessAccessibleClientPro2PackPrivSuperKey() {
		return super.protected2packageprivate;
	}
	
	public int fieldLessAccessibleClientPro2PrivSuperKey() {
		return super.protected2private;
	}
}
