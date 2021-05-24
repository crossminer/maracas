package mainclient.superclassRemoved;

import java.util.List;

import main.interfaceRemoved.IInterfaceRemoved;
import main.interfaceRemoved.InterfaceRemoved;
import main.superclassRemoved.SuperSuperclassRemoved;
import main.superclassRemoved.SuperclassRemoved;

/**
 * Reactions:
 * 1) Remove casting
 * 2) Change type intCons()
 * 3) Change type listCons()
 * 4) Change type staticM()
 * 
 * @author Lina Ochoa
 *
 */
public class SuperclassRemovedTD {

	public void cast() {
		SuperclassRemoved a = new SuperclassRemoved();
	}
	
	public void intCons() {
		int ia = SuperSuperclassRemoved.CTE;
	}
	
	public void intConsInter() {
		int ii = SuperSuperclassRemoved.CTE;
	}
	
	public void listCons() {
		List<String> la = SuperSuperclassRemoved.LIST;
	}
	
	public void listConsInter() {
		List<String> li = SuperSuperclassRemoved.LIST;
	}
	
	public void staticM() {
		int ia = SuperSuperclassRemoved.staticMeth();
	}
	
	public void staticMSuper() {
		int ii = SuperSuperclassRemoved.staticMeth();
	}

}
