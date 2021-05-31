package mainclient.fieldRemovedInSuperclass;

/**
 * Reactions:
 * - Change variable type from SFieldRemovedInSuperclass
 * to FieldRemovedInSuperclassExt
 * - Change variable type from SFieldRemovedInSuperclass
 * to FieldRemovedInSuperclassExt
 * - Remove unneeded imports
 * @author Lina Ochoa
 *
 */
public class FieldRemovedInSuperclassFA {

	public int accessSuper() {
	    FieldRemovedInSuperclassExt s = new FieldRemovedInSuperclassExt();
		return s.removedField;
	}
	
	public int accessSub() {
	    FieldRemovedInSuperclassExt s = new FieldRemovedInSuperclassExt();
		return s.removedField;
	}
}
