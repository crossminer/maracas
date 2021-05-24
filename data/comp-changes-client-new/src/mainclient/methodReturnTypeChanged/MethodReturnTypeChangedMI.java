package mainclient.methodReturnTypeChanged;

import java.util.ArrayList;

import main.methodReturnTypeChanged.MethodReturnTypeChanged;

/**
 * Reactions:
 * 1) Casting result to ArrayList listClient()
 * @author Lina Ochoa
 *
 */
public class MethodReturnTypeChangedMI {

	public long numericClient() {
		MethodReturnTypeChanged m = new MethodReturnTypeChanged();
		return m.methodReturnTypeChangedNumeric();
	}
	
	public ArrayList listClient() {
		MethodReturnTypeChanged m = new MethodReturnTypeChanged();
		return (ArrayList) m.methodReturnTypeChangedList();
	}
	
}
