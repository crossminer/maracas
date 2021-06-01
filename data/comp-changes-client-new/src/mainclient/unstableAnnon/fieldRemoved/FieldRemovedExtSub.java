package mainclient.unstableAnnon.fieldRemoved;

import main.unstableAnnon.fieldRemoved.FieldRemovedSub;

/**
 * Reactions:
 * - Change return value fieldRemovedClientExt()
 * - Change return value fieldRemovedClientSuper()
 * @author Lina Ochoa
 *
 */
public class FieldRemovedExtSub extends FieldRemovedSub {

	public int fieldRemovedClientExt() {
		return 0;
	}
	
	public int fieldRemovedClientSuper() {
		return 1;
	}
}
