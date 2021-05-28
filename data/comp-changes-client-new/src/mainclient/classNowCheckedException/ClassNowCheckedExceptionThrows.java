package mainclient.classNowCheckedException;

import main.classNowCheckedException.ClassNowCheckedException;
import main.classNowCheckedException.ClassNowCheckedExceptionSub;

/**
 * Reactions:
 * - Add throws clause throwsExcep(boolean b)
 * - Add throws clause throwsSubExcep(boolean b)
 * - Add throws clause throwsClientExcep(boolean b)
 * - Add throws clause throwsClientSubExcep(boolean b)
 * @author Lina Ochoa
 *
 */
public class ClassNowCheckedExceptionThrows {

	public int throwsExcep(boolean b) throws ClassNowCheckedException {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedException();
		}
	}
	
	public int throwsSubExcep(boolean b) throws ClassNowCheckedExceptionSub {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedExceptionSub();
		}
	}
	
	public int throwsClientExcep(boolean b) throws ClassNowCheckedExceptionClient {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedExceptionClient();
		}
	}
	
	public int throwsClientSubExcep(boolean b) throws ClassNowCheckedExceptionClientSub {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedExceptionClientSub();
		}
	}
	
	public int throwsExcepChecked(boolean b) throws ClassNowCheckedException {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedException();
		}
	}
	
	public int throwsSubExcepChecked(boolean b) throws ClassNowCheckedExceptionSub {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedExceptionSub();
		}
	}
	
	public int throwsClientExcepChecked(boolean b) throws ClassNowCheckedExceptionClient {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedExceptionClient();
		}
	}
	
	public int throwsClientSubExcepChecked(boolean b) throws ClassNowCheckedExceptionClientSub {
		if (b) {
			return 0;
		}
		else {
			throw new ClassNowCheckedExceptionClientSub();
		}
	}
}
