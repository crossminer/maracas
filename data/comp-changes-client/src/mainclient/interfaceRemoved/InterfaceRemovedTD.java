package mainclient.interfaceRemoved;

import main.interfaceRemoved.IInterfaceRemoved;

public class InterfaceRemovedTD {

	public int internalVariable() {
		IInterfaceRemoved i = new InterfaceRemovedImp();
		return i.intRemoved();
	}
}
