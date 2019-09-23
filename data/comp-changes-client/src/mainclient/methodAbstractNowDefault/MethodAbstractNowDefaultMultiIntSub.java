package mainclient.methodAbstractNowDefault;

import main.methodAbstractNowDefault.IMethodAbstractNowDefaultSub;

public class MethodAbstractNowDefaultMultiIntSub implements IMethodAbstractNowDefaultSub {
	
	@Override
	public int methodAbstractNowDef() {
		return 0;
	}
	
	public int callMethod() {
		return methodAbstractNowDef();
	}
}
