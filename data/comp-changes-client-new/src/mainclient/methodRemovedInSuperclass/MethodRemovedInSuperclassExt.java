package mainclient.methodRemovedInSuperclass;

import main.methodRemovedInSuperclass.MethodRemovedInSuperclass;

/**
 * Reactions:
 * - Remove @Override annotation from methodRemovedSAbs()
 * - Remove @Override annotation from methodRemovedSSAbs()
 * - Remove callSuperSMethod() delcaration
 * - Remove callSuperSSMethod() declaration
 * @author Lina Ochoa
 *
 */
public class MethodRemovedInSuperclassExt extends MethodRemovedInSuperclass {

	public int methodRemovedSAbs() {
		return 0;
	}
	
	public int methodRemovedSSAbs() {
		return 0;
	}
}
