package mainclient.fieldRemovedInSuperclass;


/**
 * Reactions:
 * - Remove extends
 * - Declare removedField
 * - Remove super from accessSuperKey()
 * - Remove unneeded imports
 * @author Lina Ochoa
 *
 */
public class SFieldRemovedInSuperclassExt {

    public int removedField;
    
	public int accessSuperKey() {
		return removedField;
	}
	
	public int accessNoSuperKey() {
		return removedField;
	}
}
