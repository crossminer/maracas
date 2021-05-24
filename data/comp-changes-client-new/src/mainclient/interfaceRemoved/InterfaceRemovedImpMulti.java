package mainclient.interfaceRemoved;

import main.interfaceRemoved.IInterfaceRemovedMultiMulti;

/**
 * Reactions
 * 1) Remove @Override annotation from methodAbs()
 * @author Lina Ochoa
 *
 */
public class InterfaceRemovedImpMulti implements IInterfaceRemovedMultiMulti {

	@Override
	public int mMulti() {
		return 0;
	}

	public int methodAbs() {
		return 0;
	}

	@Override
	public int mMultiMulti() {
		return 0;
	}

}
