package mainclient.classLessAccessible;


/**
 * Reactions:
 * - Remove implements
 * - Copying publicField from IClassLessAccessiblePub2PackPriv
 * - Copying publicMethod from IClassLessAccessiblePub2PackPriv
 * - Removing type access
 * - Removing unneeded import declaration
 * @author Lina Ochoa
 *
 */
public class ClassLessAccessiblePub2PackPrivImp {
    
    public static final int publicField = 1;;
    
    public static int publicMethod() {
        return 0;
    }
    
	public int accessPublicField() {
		return publicField;
	}
	
	public int accessPublicFieldStatic() {
		return publicField;
	}
	
	public int invokePublicMethod() {
		return publicMethod();
	}
}
