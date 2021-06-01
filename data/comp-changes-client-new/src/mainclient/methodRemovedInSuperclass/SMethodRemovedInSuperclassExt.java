package mainclient.methodRemovedInSuperclass;

import main.methodRemovedInSuperclass.SMethodRemovedInSuperclass;


/**
 * Reactions:
 * - Remove @Override annotation methodRemovedSAbs()
 * - Remove @Override annotation methodRemovedSSAbs()
 * - Change return value callSuperSMethod()
 * - Change return value callSuperSSMethod()
 * @author Lina Ochoa
 *
 */
public class SMethodRemovedInSuperclassExt extends SMethodRemovedInSuperclass {

	public int methodRemovedSAbs() {
		return 0;
	}

	public int methodRemovedSSAbs() {
		return 0;
	}

	public int callSuperSMethod() {
		return 1;
	}
	
	public int callSuperSSMethod() {
		return 1;
	}
}
