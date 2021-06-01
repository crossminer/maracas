package mainclient.methodNewDefault;

import main.methodNewDefault.IMethodNewDefaultOther;
import main.methodNewDefault.IMethodNewDefaultSub;

/**
 * Reactions:
 * - Override defaultMethod()
 * @author Lina Ochoa
 *
 */
public abstract class AbsMethodNewDefaultMultiIntSub implements IMethodNewDefaultSub, IMethodNewDefaultOther {

    @Override
    public int defaultMethod() {
        return IMethodNewDefaultOther.super.defaultMethod();
    }

}
