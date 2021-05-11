package mainclient.fieldRemoved;

/**
 * Reactions:
 * 1) Create local solution (i.e. IFieldRemovedClient)
 * 2) Change implements
 * 3) Remove imports
 * @author Lina Ochoa
 *
 */
public class FieldRemovedImp implements IFieldRemovedClient {

	public int fieldRemovedClient() {
		return FIELD_REMOVED;
	}
	
	public int fieldRemovedClientType() {
		return IFieldRemovedClient.FIELD_REMOVED;
	}
}
