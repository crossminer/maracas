package mainclient.methodNoLongerThrowsCheckedException;

import main.methodNoLongerThrowsCheckedException.IMethodNoLongerThrowsCheckedException;
import main.methodNoLongerThrowsCheckedException.MethodNoLongerThrowsCheckedException;
import main.methodNoLongerThrowsCheckedException.MethodNoLongerThrowsCheckedExceptionSub;

/**
 * Reactions:
 * - Remove catch clause callSuperMethod()
 * - Remove catch clause callInterMethod()
 * - Remove catch clause callSubtypeMethod()
 * - Remove catch clause callClientSubtypeMethod()
 * - Remove catch clause callImpMethod()
 * - Remove extra return callInterMethod()
 * - Remove extra return callImpMethod()
 * - Remove unneeded imports
 * @author Lina Ochoa
 *
 */
public class MethodNoLongerThrowsCheckedExceptionMI {

	public void callSuperMethod() {
		MethodNoLongerThrowsCheckedException m = new MethodNoLongerThrowsCheckedExceptionExt();
		m.noLongerThrowsExcep();
	}
	
	public int callInterMethod() {
		IMethodNoLongerThrowsCheckedException m = new MethodNoLongerThrowsCheckedExceptionImp();
		return m.noLongerThrowsExcep();
	}
	
	public void callSubtypeMethod() {
		MethodNoLongerThrowsCheckedExceptionSub m = new MethodNoLongerThrowsCheckedExceptionSub();
		m.noLongerThrowsExcep();
	}
	
	public void callClientSubtypeMethod() {
		MethodNoLongerThrowsCheckedExceptionExt m = new MethodNoLongerThrowsCheckedExceptionExt();
		m.noLongerThrowsExcep();
	}
	
	public int callImpMethod() {
		MethodNoLongerThrowsCheckedExceptionImp m = new MethodNoLongerThrowsCheckedExceptionImp();
		return m.noLongerThrowsExcep();
	}
	
}
