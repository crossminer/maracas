package mainclient.classNowCheckedException;

import main.classNowCheckedException.ClassNowCheckedException;

public class ClassNowCheckedExceptionThrows {

	public int throwsExcep(boolean b) {
		if (b) {
			return 5;
		}
		else {
			throw new ClassNowCheckedException();
		}
	}
}
