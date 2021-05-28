package mainclient.fieldNoLongerStatic;

import main.fieldNoLongerStatic.FieldNoLongerStatic;
import main.fieldNoLongerStatic.FieldNoLongerStaticSuper;

/**
 * Reactions:
 * - Create FieldNoLongerStatic variable in fieldNoLongerStaticClient()
 * - Create FieldNoLongerStatic variable in fieldNoLongerStaticSuperClient1()
 * - Create FieldNoLongerStatic variable in fieldNoLongerStaticSuperClient2()
 * - Access fieldStatic via variable
 * - Access superFieldStatic via variable
 * - Access superFieldStatic via variable
 * @author Lina Ochoa
 *
 */
public class FieldNoLongerStaticFA {

	public int fieldNoLongerStaticClient() {
	    FieldNoLongerStatic f = new FieldNoLongerStatic();
		return f.fieldStatic;
	}
	
	public int fieldNoLongerStaticSuperClient1() {
	    FieldNoLongerStatic f = new FieldNoLongerStatic();
		return f.superFieldStatic;
	}

	public int fieldNoLongerStaticSuperClient2() {
	    FieldNoLongerStaticSuper f = new FieldNoLongerStaticSuper();
		return f.superFieldStatic;
	}
}
