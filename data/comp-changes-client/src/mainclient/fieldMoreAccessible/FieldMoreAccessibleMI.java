package mainclient.fieldMoreAccessible;

import main.fieldMoreAccessible.FieldMoreAccessible;

public class FieldMoreAccessibleMI {

	private FieldMoreAccessible c;
	
	public FieldMoreAccessibleMI() {
		c = new FieldMoreAccessible();
	}
	
	public void public2packageprivate() {
		int v = c.public2packageprivate;
	}
	
	public void public2private() {
		int v = c.public2private;
	}
	
	public void public2protected() {
		int v = c.public2protected;
	}
	
}
