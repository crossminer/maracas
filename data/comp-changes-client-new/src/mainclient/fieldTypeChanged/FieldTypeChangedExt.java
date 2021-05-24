package mainclient.fieldTypeChanged;

import java.util.List;
import main.fieldTypeChanged.FieldTypeChanged;

/**
 * Reactions: 
 * 1) Changing type of i to long: fieldTypeChangedClientSuperKeyAccess()
 * 2) Changing type of i to long: fieldTypeChangedClientNoSuperKeyAccess()
 * @author Lina Ochoa
 *
 */
public class FieldTypeChangedExt extends FieldTypeChanged {

	public void fieldTypeChangedClientSuperKeyAccess() {
		long i = super.fieldNumeric;
		List l = super.fieldList;
	}
	
	public void fieldTypeChangedClientNoSuperKeyAccess() {
		long i = fieldNumeric;
		List l = fieldList;
	}
	
}
