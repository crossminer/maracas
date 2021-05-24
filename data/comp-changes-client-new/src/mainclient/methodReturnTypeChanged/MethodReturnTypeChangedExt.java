package mainclient.methodReturnTypeChanged;

import java.util.List;

import main.methodReturnTypeChanged.MethodReturnTypeChanged;

/**
 * Reactions:
 * 1) Change return type of method (ArrayList to List): listClientSuperKey()
 * 2) Change return type of method (ArrayList to List): listClientNoSuperKey()
 * 3) Remove unneded imports
 * @author Lina Ochoa
 *
 */
public class MethodReturnTypeChangedExt extends MethodReturnTypeChanged {

	public long numericClientSuperKey() {
		return super.methodReturnTypeChangedNumeric();
	}
	
	public List listClientSuperKey() {
		return super.methodReturnTypeChangedList();
	}
	
	public long numericClientNoSuperKey() {
		return methodReturnTypeChangedNumeric();
	}
	
	public List listClientNoSuperKey() {
		return methodReturnTypeChangedList();
	}
}
