package mainclient.fieldRemovedInSuperclass;

import main.fieldRemovedInSuperclass.FieldRemovedInSuperclass;

/**
 * Reactions:
 * - Declare removedField
 * - Remove super from accessSuperKey()
 * @author Lina Ochoa
 *
 */
public class FieldRemovedInSuperclassExt extends FieldRemovedInSuperclass {

    public int removedField;
    
	public int accessSuperKey() {
		return removedField;
	}
	
	public int accessNoSuperKey() {
		return removedField;
	}
}
