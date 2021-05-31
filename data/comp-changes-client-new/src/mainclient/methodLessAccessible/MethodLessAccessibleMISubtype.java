package mainclient.methodLessAccessible;

import main.methodLessAccessible.MethodLessAccessible;

/**
 * Reactions:
 * - Remove declaration methodLessAccessiblePub2PackPrivClientSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePub2PrivClientSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePro2PackPrivClientSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePro2PrivClientSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePub2PackPrivClientNoSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePub2PrivClientNoSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePro2PackPrivClientNoSuperKeyAccess()
 * - Remove declaration methodLessAccessiblePro2PrivClientNoSuperKeyAccess()
 * @author Lina Ochoa
 *
 */
public class MethodLessAccessibleMISubtype extends MethodLessAccessible {

	public int methodLessAccessiblePub2ProClientSuperKeyAccess() {
		return super.methodLessAccessiblePublic2Protected();
	}
	
	public int methodLessAccessiblePro2PubClientSuperKeyAccess() {
		return super.methodLessAccessibleProtected2Public();
	}
	
	public int methodLessAccessiblePub2ProClientNoSuperKeyAccess() {
		return methodLessAccessiblePublic2Protected();
	}
	
	public int methodLessAccessiblePro2PubClientNoSuperKeyAccess() {
		return methodLessAccessibleProtected2Public();
	}
	
}
