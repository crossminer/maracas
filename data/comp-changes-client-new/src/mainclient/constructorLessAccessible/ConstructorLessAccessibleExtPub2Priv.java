package mainclient.constructorLessAccessible;


/**
 * Reactions:
 * - Create local class ConstructorLessAccessiblePub2PackPriv
 * - Remove unneeded import declaration
 * @author Lina Ochoa
 *
 */
public class ConstructorLessAccessibleExtPub2Priv extends ConstructorLessAccessiblePub2Priv {

	public ConstructorLessAccessibleExtPub2Priv() {
		super();
	}
	
	public ConstructorLessAccessibleExtPub2Priv(int i) {
		super(i);
	}
}
