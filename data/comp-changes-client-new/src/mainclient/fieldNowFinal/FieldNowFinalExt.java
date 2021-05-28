package mainclient.fieldNowFinal;

import main.fieldNowFinal.FieldNowFinal;

/**
 * Reactions:
 * - Remove field assignment fieldNowFinalAssignmentSuperKey()
 * - Remove field assignment fieldNowFinalAssignmentNoSuperKey()
 * @author Lina Ochoa
 *
 */
public class FieldNowFinalExt extends FieldNowFinal {

	public int fieldNowFinalAssignmentSuperKey() {
		return super.fieldFinal;
	}
	
	public int fieldNowFinalNoAssignmentSuperKey() {
		return super.fieldFinal;
	}
	
	public int fieldNowFinalAssignmentNoSuperKey() {
		return fieldFinal;
	}
	
	public int fieldNowFinalNoAssignmentNoSuperKey() {
		return fieldFinal;
	}
	
}
