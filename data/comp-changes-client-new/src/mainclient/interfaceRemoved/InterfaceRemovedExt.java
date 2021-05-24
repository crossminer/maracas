package mainclient.interfaceRemoved;

import java.util.List;

import main.interfaceRemoved.IInterfaceRemoved;
import main.interfaceRemoved.InterfaceRemoved;


/**
 * Reactions:
 * 1) Replace type InterfaceRemoved by IInterfaceRemoved (intCons())
 * 2) Replace type InterfaceRemoved by IInterfaceRemoved (listCons())
 * 3) Add type IInterfaceRemoved (intConsDirect())
 * 4) Add type IInterfaceRemoved (listConsDirect())
 * 5) Copy defaultMeth() declaration
 * @author Lina Ochoa
 *
 */
public class InterfaceRemovedExt extends InterfaceRemoved {

	public void cast() {
		InterfaceRemoved a = new InterfaceRemoved();
		IInterfaceRemoved i = (IInterfaceRemoved) a;
	}
	
	public void intCons() {
		int ia = IInterfaceRemoved.CTE;
	}
	
	public void intConsInter() {
		int ii = IInterfaceRemoved.CTE;
	}
	
	public void intConsDirect() {
		int in = IInterfaceRemoved.CTE;
	}
	
	public void listCons() {
		List<String> la = IInterfaceRemoved.LIST;
	}
	
	public void listConsInter() {
		List<String> li = IInterfaceRemoved.LIST;
	}
	
	public void listConsDirect() {
		List<String> ln = IInterfaceRemoved.LIST;
	}
	
	public void staticM() {
		//int ia = InterfaceRemoved.staticMeth(); Cannot happen
		int ii = IInterfaceRemoved.staticMeth();
		//int in = staticMethos(); Cannot happen
	}
	
	public void defaultM() {
		//int ia = InterfaceRemoved.defaultMeth(); Cannot happen
		//int ii = IInterfaceRemoved.super.defaultMeth(); Cannot happen
		int in = defaultMeth();
	}
	
	public int defaultMeth() {
        return 1;
    }
}
