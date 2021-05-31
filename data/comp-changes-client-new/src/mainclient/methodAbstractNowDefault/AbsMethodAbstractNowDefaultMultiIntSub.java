package mainclient.methodAbstractNowDefault;

import main.methodAbstractNowDefault.IMethodAbstractNowDefaultOther;
import main.methodAbstractNowDefault.IMethodAbstractNowDefaultSub;

/**
 * Reactions:
 * - Implement methodAbstractNowDef()
 * @author Lina Ochoa
 *
 */
public abstract class AbsMethodAbstractNowDefaultMultiIntSub implements IMethodAbstractNowDefaultSub, IMethodAbstractNowDefaultOther {

    @Override
    public int methodAbstractNowDef() {
        return 0;
    }

}
