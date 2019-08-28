package mainclient;

import main.IFieldRemoved;

public class FieldRemovedImp implements IFieldRemoved {

	public int fieldRemovedClient() {
		return FIELD_REMOVED;
	}
	
	public int fieldRemovedClientType() {
		return IFieldRemoved.FIELD_REMOVED;
	}
}
