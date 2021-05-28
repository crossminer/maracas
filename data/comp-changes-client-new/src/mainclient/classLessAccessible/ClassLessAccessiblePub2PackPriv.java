package mainclient.classLessAccessible;

/**
 * Copied from old API
 * @author Lina Ochoa
 *
 */
class ClassLessAccessiblePub2PackPriv {
    
    public int publicField;
    private int privateField;
    
    public int publicMethod() {
        return 0;
    }
    
    public int privateMethod() {
        return 0;
    }
}