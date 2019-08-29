package mainclient.classNowAbstract;

import main.classNowAbstract.ClassNowAbstract;

public class ClassNowAbstractMI {

	public void createObject() {
		ClassNowAbstract c = new ClassNowAbstract();
	}
	
	public void createObjectParams() {
		ClassNowAbstract c = new ClassNowAbstract(3);
	}
	
	public void accessConstant() {
		int i = ClassNowAbstract.CTE;
	}
}
