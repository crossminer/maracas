package mainclient.classLessAccessible;

import main.classLessAccessible.ClassLessAccessiblePub2Priv;

/**
 * Reactions:
 * - Removing ClassLessAccessiblePub2PrivInner object
 *   creation
 * - Change type c2 to ClassLessAccessiblePub2PrivExtInner
 * - Removing extends inner class
 * - Copying publicField inner class
 * - Copying methodPublic inner class
 * - Removing use of super
 * @author Lina Ochoa
 *
 */
public class ClassLessAccessiblePub2PrivExt extends ClassLessAccessiblePub2Priv {

	public void instantiatePub2Priv() {
	    ClassLessAccessiblePub2PrivExtInner c2 = new ClassLessAccessiblePub2PrivExtInner();
	}
	
	public class ClassLessAccessiblePub2PrivExtInner {
		
	    public int publicField;
        
        public int publicMethod() {
            return 0;
        }
        
		public int accessPublicField() {
			return publicField;
		}
		
		public int invokePublicMethod() {
			return publicMethod();
		}
	}
}
