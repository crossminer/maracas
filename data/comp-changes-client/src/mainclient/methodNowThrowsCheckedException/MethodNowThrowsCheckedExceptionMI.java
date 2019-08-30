package mainclient.methodNowThrowsCheckedException;

import main.methodNowThrowsCheckedException.IMethodNowThrowsCheckedException;
import main.methodNowThrowsCheckedException.MethodNowThrowsCheckedException;

public class MethodNowThrowsCheckedExceptionMI {

	public int callSuperMethod() {
		MethodNowThrowsCheckedException m = new MethodNowThrowsCheckedExceptionExt();
		return m.nowThrowsExcep();
	}
	
	public int callInterMethod() {
		IMethodNowThrowsCheckedException m = new MethodNowThrowsCheckedExceptionImp();
		return m.nowThrowsExcep();
	}
	
	public int callSubtypeMethod() {
		MethodNowThrowsCheckedExceptionExt m = new MethodNowThrowsCheckedExceptionExt();
		return m.nowThrowsExcep();
	}
	
	public int callImpMethod() {
		MethodNowThrowsCheckedExceptionImp m = new MethodNowThrowsCheckedExceptionImp();
		return m.nowThrowsExcep();
	}
	
}
