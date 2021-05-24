package mainclient.superclassRemoved;

import java.util.ArrayList;
import java.util.List;

import main.interfaceRemoved.IInterfaceRemoved;
import main.superclassRemoved.SuperSuperclassRemoved;
import main.superclassRemoved.SuperclassRemoved;

/**
 * Reactions:
 * 1) Remove casting
 * 2) Change type intCons()
 * 3) Change type listCons()
 * 4) Create CTE constant
 * 5) Create LIST constant
 * 6) Change type staticM()
 * 7) Create local method staticMeth()
 * 
 * @author Lina Ochoa
 *
 */
public class SuperclassRemovedExt extends SuperclassRemoved {

    public static final int CTE = 0;
    public static final List<String> LIST = new ArrayList<String>();
    
	public void cast() {
		SuperclassRemoved a = new SuperclassRemoved();
	}
	
	public void intCons() {
		int ia = SuperSuperclassRemoved.CTE;
	}
	
	public void intConsSuper() {
		int ii = SuperSuperclassRemoved.CTE;
	}
	
	public void intConsDirect() {
		int in = CTE;
	}
	
	public void listCons() {
		List<String> la = SuperSuperclassRemoved.LIST;
	}
	
	public void listConsSuper() {
		List<String> li = SuperSuperclassRemoved.LIST;
	}
	
	public void listConsDirect() {
		List<String> ln = LIST;
	}
	
	public void staticM() {
		int ia = SuperSuperclassRemoved.staticMeth();
	}
	
	public void staticMSuper() {
		int ii = SuperSuperclassRemoved.staticMeth();
	}
	
	public void staticMDirect() {
		int in = staticMeth();
	}
	
	public int staticMeth() {
        return 0;
    }
}
