package mainclient.methodNewDefault;

import main.methodNewDefault.IMethodNewDefault;
import main.methodNewDefault.IMethodNewDefaultOther;

/**
 * Reactions:
 * - Override defaultMethod()
 * @author Lina Ochoa
 *
 */
public abstract class AbsMethodNewDefaultMultiInt implements IMethodNewDefault, IMethodNewDefaultOther {

    @Override
    public int defaultMethod() {
        return IMethodNewDefault.super.defaultMethod();
    }

}
