package mainclient.unstableAnnon.fieldRemoved;

import main.unstableAnnon.fieldRemoved.FieldRemoved;

/**
 * Reaction:
 * - Create local field
 * - Remove super field access fieldRemovedClientSuper()
 * @author Lina Ochoa
 *
 */
public class FieldRemovedExt extends FieldRemoved {

    private int fieldRemoved;
    
	public int fieldRemovedClientExt() {
		return fieldRemoved;
	}
	
	public int fieldRemovedClientSuper() {
		return fieldRemoved;
	}
}
