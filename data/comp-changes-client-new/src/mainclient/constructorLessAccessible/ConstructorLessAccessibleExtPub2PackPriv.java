package mainclient.constructorLessAccessible;


/**
 * Reactions:
 * - Create local class ConstructorLessAccessiblePub2PackPriv
 * - Remove unneeded import declaration
 * @author Lina Ochoa
 *
 */
public class ConstructorLessAccessibleExtPub2PackPriv extends ConstructorLessAccessiblePub2PackPriv {

	public ConstructorLessAccessibleExtPub2PackPriv() {
		super();
	}
	
	public ConstructorLessAccessibleExtPub2PackPriv(int i) {
		super(i);
	}
	
}
