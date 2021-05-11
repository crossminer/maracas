package mainclient.fieldRemoved;

/**
 * Reactions:
 * 1) Create local solution (i.e. FieldRemovedClient)
 * 2) Change extends
 * 3) Remove imports
 * @author Lina Ochoa
 *
 */
public class FieldRemovedExt extends FieldRemovedClient {

	public int fieldRemovedClientExt() {
		return fieldRemoved;
	}
	
	public int fieldRemovedClientSuper() {
		return super.fieldRemoved;
	}
}
