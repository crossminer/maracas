package mainclient.methodReturnTypeChanged;

import java.util.ArrayList;

import main.methodReturnTypeChanged.IMethodReturnTypeChanged;

/**
 * Reactions:
 * 1) Change type from long to int: methodReturnTypeChangedNumeric()
 * @author Lina Ochoa
 *
 */
public class MethodReturnTypeChangedImp implements IMethodReturnTypeChanged {

	@Override
	public ArrayList methodReturnTypeChangedList() {
		return new ArrayList();
	}

	@Override
	public int methodReturnTypeChangedNumeric() {
		return 1;
	}

}
