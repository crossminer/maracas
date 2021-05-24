package mainclient.methodAddedToInterface;

import main.methodAddedToInterface.MethodAddedToInterfaceInner;

/**
 * Reactions:
 * 1) Adding method implementation 
 * @author Lina Ochoa
 *
 */
public class MethodAddedToInterfaceInnerExt extends MethodAddedToInterfaceInner {
	public class Inner implements I {

        @Override
        public int newMethod() {
            return 0;
        }
		
	}
}
