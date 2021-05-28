package mainclient.classLessAccessible;


/**
 * Reactions:
 * - Copying inner class
 * - Remove extends
 * - Remove unneeded import declaration
 * @author Lina Ochoa
 *
 */
public class ClassLessAccessiblePro2PackPrivExt {

    public void instantiatePro2PackPriv() {
        ClassLessAccessiblePro2PackPrivInner c = new ClassLessAccessiblePro2PackPrivExtInner();
    }

    public class ClassLessAccessiblePro2PackPrivExtInner extends ClassLessAccessiblePro2PackPrivInner {

        public int accessPublicField() {
            return super.publicField;
        }

        public int invokePublicMethod() {
            return super.publicMethod();
        }
    }

    class ClassLessAccessiblePro2PackPrivInner {

        public int publicField;
        private int privateField;

        public int publicMethod() {
            return 0;
        }

        public int privateMethod() {
            return 0;
        }
    }
}
