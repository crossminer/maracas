package mainclient.fieldTypeChanged;

import java.util.List;

import main.fieldTypeChanged.FieldTypeChanged;
import main.fieldTypeChanged.FieldTypeChangedSub;

public class FieldTypeChangedFA {

	public void fieldTypeChangedClient() {
		FieldTypeChanged f = new FieldTypeChanged();
		int i = f.fieldNumeric;
		List l = f.fieldList;
	}
	
	public void fieldTypeChangedClientSub() {
		FieldTypeChangedSub f = new FieldTypeChangedSub();
		int i = f.fieldNumeric;
		List l = f.fieldList;
	}
}
