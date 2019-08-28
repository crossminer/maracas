package mainclient;

import java.util.List;

import main.FieldTypeChanged;

public class FieldTypeChangedExt extends FieldTypeChanged {

	public void fieldTypeChangedClientSuperKeyAccess() {
		int i = super.fieldNumeric;
		List l = super.fieldList;
	}
	
	public void fieldTypeChangedClientNoSuperKeyAccess() {
		int i = fieldNumeric;
		List l = fieldList;
	}
	
}
