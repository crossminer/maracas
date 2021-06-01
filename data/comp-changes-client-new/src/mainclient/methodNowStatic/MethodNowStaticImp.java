package mainclient.methodNowStatic;

import main.methodNowStatic.IMethodNowStatic;

/**
 * Reactions:
 * - Add static invocation methodNowStaticClient()
 * @author Lina Ochoa
 *
 */
public class MethodNowStaticImp implements IMethodNowStatic {

	public int methodNowStaticClient() {
		return IMethodNowStatic.methodNowStatic();
	}
}
