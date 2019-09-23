package mainclient.classLessAccessible;

import main.classLessAccessible.ClassLessAccessiblePub2Priv;

public class ClassLessAccessiblePub2PrivExt extends ClassLessAccessiblePub2Priv {

	public class ClassLessAccessiblePub2PrivExtInner extends ClassLessAccessiblePub2PrivInner {
		
		public int accessPublicField() {
			return super.publicField;
		}
		
		public int invokePublicMethod() {
			return super.publicMethod();
		}
	}
}
