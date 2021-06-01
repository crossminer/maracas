package mainclient.methodNowThrowsCheckedException;

import java.io.IOException;

import main.methodNowThrowsCheckedException.IMethodNowThrowsCheckedException;
import main.methodNowThrowsCheckedException.MethodNowThrowsCheckedException;
import main.methodNowThrowsCheckedException.MethodNowThrowsCheckedExceptionSub;

/**
 * Reactions:
 * - Surround method invocation with try-catch callSubtypeMethod()
 * - Add throws declaration callInterMethod()
 * - Add throws declaration callSuperMethod
 * @author Lina Ochoa
 *
 */
public class MethodNowThrowsCheckedExceptionMI {

	public void callSuperMethod() throws IOException {
		MethodNowThrowsCheckedException m = new MethodNowThrowsCheckedExceptionExt();
		m.nowThrowsExcep();
	}
	
	public int callInterMethod() throws IOException {
		IMethodNowThrowsCheckedException m = new MethodNowThrowsCheckedExceptionImp();
		return m.nowThrowsExcep();
	}
	
	public void callSubtypeMethod() {
		MethodNowThrowsCheckedExceptionSub m = new MethodNowThrowsCheckedExceptionSub();
		try {
            m.nowThrowsExcep();
        } catch (IOException e) {
            e.printStackTrace();
        }
	}
	
	public void callClientSubtypeMethod() {
		MethodNowThrowsCheckedExceptionExt m = new MethodNowThrowsCheckedExceptionExt();
		m.nowThrowsExcep();
	}
	
	public int callImpMethod() {
		MethodNowThrowsCheckedExceptionImp m = new MethodNowThrowsCheckedExceptionImp();
		return m.nowThrowsExcep();
	}
	
}
