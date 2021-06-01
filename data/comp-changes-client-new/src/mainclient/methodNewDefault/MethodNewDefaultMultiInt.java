package mainclient.methodNewDefault;

import main.methodNewDefault.IMethodNewDefaultOther;

/**
 * Reactions:
 * - Remove implements IMethodNewDefault
 * - Remove unneeded imports
 * @author Lina Ochoa
 *
 */
public class MethodNewDefaultMultiInt implements IMethodNewDefaultOther {

	public int callDefaultMethodOther() {
		return defaultMethod();
	}
	
	public int callDefaultMethodOtherSuper() {
		return IMethodNewDefaultOther.super.defaultMethod();
	}
}
