package mainclient.fieldNowFinal;

import main.fieldNowFinal.FieldNowFinalSub;

/**
 * Reactions:
 * - Replace super.fieldFinal by variable
 * - Replace fieldFinal by variable
 * - Change return object fieldNowFinalAssignmentSuperKey()
 * - Change return object fieldNowFinalAssignmentNoSuperKey()
 * @author Lina Ochoa
 *
 */
public class FieldNowFinalExtSub extends FieldNowFinalSub {

	public int fieldNowFinalAssignmentSuperKey() {
		int i = 3;
		return i;
	}
	
	public int fieldNowFinalNoAssignmentSuperKey() {
		return super.fieldFinal;
	}
	
	public int fieldNowFinalAssignmentNoSuperKey() {
	    int i = 3;
        return i;
	}
	
	public int fieldNowFinalNoAssignmentNoSuperKey() {
		return fieldFinal;
	}
	
}
