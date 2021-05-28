package mainclient.fieldLessAccessible;

import main.fieldLessAccessible.FieldLessAccessible;

/**
 * Reactions:
 * - Create public2protected field
 * - Create public2packageprivate field
 * - Create superPublic2Protected field
 * - Initialize public2protected in the class constuctor
 * - Initialize public2packageprivate in the class constuctor
 * - Initialize superPublic2Protected in the class constuctor
 * - Replace public2private by specific value
 * - Replace superPublic2Private by specific value
 * - Replace superPublic2PackagePrivate by specific value
 * @author Lina Ochoa
 *
 */
public class FieldLessAccessibleFA {

	private FieldLessAccessible f;
	private int public2protected;
	private int public2packageprivate;
	private int superPublic2Protected;
	
	public FieldLessAccessibleFA() {
		f = new FieldLessAccessible();
		public2protected = 0;
		public2packageprivate = 1;
		superPublic2Protected = 2;
	}
	
	public int fieldLessAccessibleClientPub2Pro() {
		return public2protected;
	}
	
	public int fieldLessAccessibleClientPub2PackPriv() {
		return public2packageprivate;
	}
	
	public int fieldLessAccessibleClientPub2Priv() {
		return 0;
	}

	public int fieldLessAccessibleSuperPublic2Private() {
		return 1;
	}

	public int fieldLessAccessibleSuperPublic2Protected() {
		return superPublic2Protected;
	}
	
	public int fieldLessAccessibleSuperPublic2PackagePrivate() {
		return 2;
	}
}
