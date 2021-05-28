package mainclient.constructorLessAccessible;

import main.constructorLessAccessible.ConstructorLessAccessiblePub2PackPriv;
import main.constructorLessAccessible.ConstructorLessAccessiblePub2Priv;
import main.constructorLessAccessible.ConstructorLessAccessiblePub2Pro;

/**
 * Reactions:
 * - Remove c1 initialization
 * - Remove c2 initialization
 * - Remove c3 initialization
 * @author Lina Ochoa
 *
 */
public class ConstructorLessAccessibleMI {

	public void clientPublic() {
		ConstructorLessAccessiblePub2Pro c1;
		ConstructorLessAccessiblePub2PackPriv c2;
		ConstructorLessAccessiblePub2Priv c3;
	}
	
}
