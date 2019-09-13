package mainclient.fieldNowFinal;

import main.fieldNowFinal.FieldNowFinal;

public class FieldNowFinalFA {

	public int fieldNowFinalAssignment() {
		FieldNowFinal f = new FieldNowFinal();
		f.fieldFinal = 3;
		return f.fieldFinal;
	}
	
	public int fieldNowFinalNoAssignment() {
		FieldNowFinal f = new FieldNowFinal();
		return f.fieldFinal;
	}
}
