package mainclient.fieldMoreAccessible;

import main.fieldMoreAccessible.FieldMoreAccessible;

/**
 * Reactions:
 * - Replace public2packageprivate by specific value
 * - Replace public2private by specific value
 * - Replace public2protected by specific value
 * @author Lina Ochoa
 *
 */
public class FieldMoreAccessibleMI {

	private FieldMoreAccessible c;
	
	public FieldMoreAccessibleMI() {
		c = new FieldMoreAccessible();
	}
	
	public void public2packageprivate() {
		int v = 0;
	}
	
	public void public2private() {
		int v = 1;
	}
	
	public void public2protected() {
		int v = 2;
	}
	
}
