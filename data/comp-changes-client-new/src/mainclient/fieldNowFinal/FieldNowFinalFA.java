package mainclient.fieldNowFinal;

import main.fieldNowFinal.FieldNowFinal;
import main.fieldNowFinal.FieldNowFinalSub;

/**
 * Reactions:
 * - Remove object creation fieldNowFinalAssignment()
 * - Remove object creation fieldNowFinalAssignmentSub()
 * - Remove fieldFinal assignment fieldNowFinalAssignment()
 * - Remove fieldFinal assignment fieldNowFinalAssignmentSub()
 * - Return specific value fieldNowFinalAssignment()
 * - Return specific value fieldNowFinalAssignmentSub()
 * @author Lina Ochoa
 *
 */
public class FieldNowFinalFA {

	public int fieldNowFinalAssignment() {
		return 3;
	}
	
	public int fieldNowFinalNoAssignment() {
		FieldNowFinal f = new FieldNowFinal();
		return f.fieldFinal;
	}
	
	public int fieldNowFinalAssignmentSub() {
		return 3;
	}
	
	public int fieldNowFinalNoAssignmentSub() {
		FieldNowFinalSub f = new FieldNowFinalSub();
		return f.fieldFinal;
	}
}
