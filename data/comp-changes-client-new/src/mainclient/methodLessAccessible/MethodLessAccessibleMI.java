package mainclient.methodLessAccessible;


/**
 * Reactions:
 * - Remove field m
 * - Remove constructor
 * - Copy methodLessAccessiblePublic2Protected()
 * - Copy methodLessAccessiblePublic2PackPriv()
 * - Copy methodLessAccessiblePublic2Private()
 * - Change method invocation methodLessAccessiblePub2ProClientSimpleAccess()
 * - Change method invocation methodLessAccessiblePub2PackPrivClientSimpleAccess()
 * - Change method invocation methodLessAccessiblePub2PrivClientSimpleAccess()
 * - Remove unneeded imports
 * @author Lina Ochoa
 *
 */
public class MethodLessAccessibleMI {

	public int methodLessAccessiblePub2ProClientSimpleAccess() {
		return methodLessAccessiblePublic2Protected();
	}
	
	public int methodLessAccessiblePub2PackPrivClientSimpleAccess() {
		return methodLessAccessiblePublic2PackPriv();
	}
	
	public int methodLessAccessiblePub2PrivClientSimpleAccess() {
		return methodLessAccessiblePublic2Private();
	}
	
	protected int methodLessAccessiblePublic2Protected() {
        return 0;
    }
	
	int methodLessAccessiblePublic2PackPriv() {
        return 1;
    }
	
	private int methodLessAccessiblePublic2Private() {
        return 2;
    }
}
