package mainclient.methodLessAccessible;

import main.methodLessAccessible.MethodLessAccessible;

/**
 * Reactions:
 * - Remove @Override from methodLessAccessiblePublic2PackPriv()
 * - Remove @Override from methodLessAccessiblePublic2Private()
 * - Remove @Override from methodLessAccessibleProtected2PackPriv()
 * - Remove @Override from methodLessAccessibleProtected2Private()
 * - Change visibility from protected to public 
 * methodLessAccessibleProtected2Public() 
 * @author Lina Ochoa
 *
 */
public class MethodLessAccessibleExt extends MethodLessAccessible {

	@Override
	public int methodLessAccessiblePublic2Protected() {
		return 100;
	}
	
	public int methodLessAccessiblePublic2PackPriv() {
		return 101;
	}
	
	public int methodLessAccessiblePublic2Private() {
		return 102;
	}
	
	@Override
	public int methodLessAccessibleProtected2Public() {
		return 103;
	}
	
	protected int methodLessAccessibleProtected2PackPriv() {
		return 104;
	}
	
	protected int methodLessAccessibleProtected2Private() {
		return 105;
	}

}
