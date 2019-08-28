package mainclient;

import main.FieldLessAccessible;

public class FieldLessAccessibleFA {

	private FieldLessAccessible f;
	
	public FieldLessAccessibleFA() {
		f = new FieldLessAccessible();
	}
	
	public int fieldLessAccessibleClientPub2Pro() {
		return f.public2protected;
	}
	
	public int fieldLessAccessibleClientPub2PackPriv() {
		return f.public2packageprivate;
	}
	
	public int fieldLessAccessibleClientPub2Priv() {
		return f.public2private;
	}
}
