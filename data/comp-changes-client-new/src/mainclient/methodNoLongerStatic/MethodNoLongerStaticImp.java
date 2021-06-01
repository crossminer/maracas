package mainclient.methodNoLongerStatic;

import main.methodNoLongerStatic.IMethodNoLongerStatic;

/**
 * Reactions:
 * - Add unimplemented methodNoLongerStatic()
 * - Remove static invocation methodNoLongerStaticClient()
 * @author Lina Ochoa
 *
 */
public class MethodNoLongerStaticImp implements IMethodNoLongerStatic {
	
	public int methodNoLongerStaticClient() {
		return methodNoLongerStatic();
	}

    @Override
    public int methodNoLongerStatic() {
        return 0;
    }
}
