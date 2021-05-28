package mainclient.classNoLongerPublic;


/**
 * Reactions:
 * - Copying ClassNoLongerPublic in client project
 * - Removing unneeded import declaration
 * @author Lina Ochoa
 *
 */
public class ClassNoLongerPublicExt extends ClassNoLongerPublic {

	public void accessNoSuperField() {
		int i = field;
	}
	
	public void accessSuperField() {
		int i = super.field;
	}
	
	public void accessNoSuperMethod() {
		int i = method();
	}
	
	public void accessSuperMethod() {
		int i = super.method();
	}
}
