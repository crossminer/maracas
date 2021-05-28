package mainclient.classLessAccessible;

import main.classLessAccessible.ClassLessAccessiblePub2Pro;

/**
 * Reactions:
 * - Removing c1 instantiation
 * @author Lina Ochoa
 *
 */
public class ClassLessAccessiblePub2ProExt extends ClassLessAccessiblePub2Pro {

	public void instantiatePub2Pro() {
		ClassLessAccessiblePub2ProInner c2 = new ClassLessAccessiblePub2ProExtInner();
	}
	
	public class ClassLessAccessiblePub2ProExtInner extends ClassLessAccessiblePub2ProInner {
		
		public int accessPublicField() {
			return super.publicField;
		}
		
		public int invokePublicMethod() {
			return super.publicMethod();
		}
	}
}
