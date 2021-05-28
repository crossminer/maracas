package mainclient.classLessAccessible;


/**
 * Reactions:
 * - Copying inner class
 * - Remove extends
 * - Remove unneeded import declaration
 * @author Lina Ochoa
 *
 */
public class ClassLessAccessiblePro2PrivExt {

	public void instantiatePro2Priv() {
		ClassLessAccessiblePro2PrivInner c = new ClassLessAccessiblePro2PrivExtInner();
	}
	
	public class ClassLessAccessiblePro2PrivExtInner extends ClassLessAccessiblePro2PrivInner {
		
		public int accessPublicField() {
			return super.publicField;
		}
		
		public int invokePublicMethod() {
			return super.publicMethod();
		}
	}
	
	private class ClassLessAccessiblePro2PrivInner {
        
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
