package mainclient.unstableAnnon.methodRemoved;

import main.unstableAnnon.methodRemoved.MethodRemoved;

/**
 * Reactions:
 * - Create local methodRemoved()
 * - Remove super invocation methodRemovedClientSuper()
 * @author Lina Ochoa
 *
 */
public class MethodRemovedExt extends MethodRemoved {

	public int methodRemovedClientExt() {
		return methodRemoved();
	}

    public int methodRemovedClientSuper() {
		return methodRemoved();
	}
    
    private int methodRemoved() {
        return 0;
    }
}
