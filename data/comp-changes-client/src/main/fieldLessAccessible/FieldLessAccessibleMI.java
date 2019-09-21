package main.fieldLessAccessible;

public class FieldLessAccessibleMI {

	public void clientPublic() {
		FieldLessAccessible c = new FieldLessAccessible();
		int i = c.public2packageprivate;
	}
	
	public void clientProtected() {
		FieldLessAccessible c = new FieldLessAccessible();
		int i = c.protected2packageprivate;
	}
}
