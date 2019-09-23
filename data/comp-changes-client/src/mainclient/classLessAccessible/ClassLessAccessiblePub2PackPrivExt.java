package mainclient.classLessAccessible;

import main.classLessAccessible.ClassLessAccessiblePub2PackPriv;

public class ClassLessAccessiblePub2PackPrivExt extends ClassLessAccessiblePub2PackPriv {

	public int accessPublicField() {
		return super.publicField;
	}
	
	public int invokePublicMethod() {
		return super.publicMethod();
	}
}
