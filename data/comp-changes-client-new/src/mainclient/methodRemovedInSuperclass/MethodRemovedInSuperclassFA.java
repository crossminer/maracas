package mainclient.methodRemovedInSuperclass;


/**
 * Reactions:
 * - Change variable type to MethodRemovedInSuperclassExt
 * in accessSuperSAbs()
 * - Change variable type to MethodRemovedInSuperclassExt
 * in accessSuperAbs()
 * - Remove declaration accessSuper()
 * - Remove declaration accessSuperS()
 * - Remove unnneded imports
 * @author Lina Ochoa
 *
 */
public class MethodRemovedInSuperclassFA {

	public int accessSuperSAbs() {
	    MethodRemovedInSuperclassExt s = new MethodRemovedInSuperclassExt();
		return s.methodRemovedSSAbs();
	}
	
	public int accessSuperAbs() {
	    MethodRemovedInSuperclassExt s = new MethodRemovedInSuperclassExt();
		return s.methodRemovedSAbs();
	}
}
