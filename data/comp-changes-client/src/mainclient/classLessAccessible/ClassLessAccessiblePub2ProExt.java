package mainclient.classLessAccessible;

import main.classLessAccessible.ClassLessAccessiblePub2Pro;

public class ClassLessAccessiblePub2ProExt extends ClassLessAccessiblePub2Pro {

	public class ClassLessAccessiblePub2ProExtInner extends ClassLessAccessiblePub2ProInner {
		
		public int accessPublicField() {
			return super.publicField;
		}
		
		public int invokePublicMethod() {
			return super.publicMethod();
		}
	}
}
