package mainclient.fieldTypeChanged;

import java.util.List;
import main.fieldTypeChanged.FieldTypeChangedSub;

public class FieldTypeChangedExtSub extends FieldTypeChangedSub {

	public void fieldTypeChangedClientSuperKeyAccess() {
		int i = super.fieldNumeric;
		List l = super.fieldList;
	}
	
	public void fieldTypeChangedClientNoSuperKeyAccess() {
		int i = fieldNumeric;
		List l = fieldList;
	}
	
}
