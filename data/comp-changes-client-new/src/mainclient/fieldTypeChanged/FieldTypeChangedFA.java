package mainclient.fieldTypeChanged;

import java.util.List;

import main.fieldTypeChanged.FieldTypeChanged;
import main.fieldTypeChanged.FieldTypeChangedSub;

/**
 * Reactions: 
 * 1) Changing type of i to long: fieldTypeChangedClient()
 * 2) Changing type of i to long: fieldTypeChangedClientSub()
 * @author Lina Ochoa
 *
 */
public class FieldTypeChangedFA {

	public void fieldTypeChangedClient() {
		FieldTypeChanged f = new FieldTypeChanged();
		long i = f.fieldNumeric;
		List l = f.fieldList;
	}
	
	public void fieldTypeChangedClientSub() {
		FieldTypeChangedSub f = new FieldTypeChangedSub();
		long i = f.fieldNumeric;
		List l = f.fieldList;
	}
}
