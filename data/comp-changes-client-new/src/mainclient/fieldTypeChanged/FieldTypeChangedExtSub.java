package mainclient.fieldTypeChanged;

import java.util.List;
import main.fieldTypeChanged.FieldTypeChangedSub;

/**
 * Reactions: 
 * 1) Casting i to int: fieldTypeChangedClientSuperKeyAccess()
 * 2) Changing i to int: fieldTypeChangedClientNoSuperKeyAccess()
 * @author Lina Ochoa
 *
 */
public class FieldTypeChangedExtSub extends FieldTypeChangedSub {

	public void fieldTypeChangedClientSuperKeyAccess() {
		int i = (int) super.fieldNumeric;
		List l = super.fieldList;
	}
	
	public void fieldTypeChangedClientNoSuperKeyAccess() {
		int i = (int) fieldNumeric;
		List l = fieldList;
	}
	
}
