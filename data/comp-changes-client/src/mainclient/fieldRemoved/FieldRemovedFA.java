package mainclient.fieldRemoved;

import main.fieldRemoved.FieldRemoved;
import main.fieldRemoved.FieldRemovedSub;

public class FieldRemovedFA {

	public int fieldRemovedClient() {
		FieldRemoved fr = new FieldRemoved();
		return fr.fieldRemoved;
	}
	
	public int fieldRemovedClientSub() {
		FieldRemovedSub fr = new FieldRemovedSub();
		return fr.fieldRemoved;
	}
}
