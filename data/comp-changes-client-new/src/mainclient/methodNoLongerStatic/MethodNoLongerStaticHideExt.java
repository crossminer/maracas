package mainclient.methodNoLongerStatic;

import main.methodNoLongerStatic.MethodNoLongerStatic;

/**
 * Reactions:
 * - Remove static modifier methodNoLongerStatic()
 * @author Lina Ochoa
 *
 */
public class MethodNoLongerStaticHideExt extends MethodNoLongerStatic {

	public int methodNoLongerStatic() {
		return 0;
	}
	
	public static int methodRemainsStatic() {
		return 0;
	}
}
