package mainclient.methodNewDefault;

import main.methodNewDefault.IMethodNewDefaultSub;

/**
 * Reactions:
 * - Change type callDefaultMethodOtherSuper()
 * from IMethodNewDefaultOther to IMethodNewDefaultSub
 * - Remove implements IMethodNewDefaultOther
 * - Remove unneeded imports
 * @author Lina Ochoa
 *
 */
public class MethodNewDefaultMultiIntSub implements IMethodNewDefaultSub {

	public int callDefaultMethodOther() {
		return defaultMethod();
	}
	
	public int callDefaultMethodOtherSuper() {
		return IMethodNewDefaultSub.super.defaultMethod();
	}
}
