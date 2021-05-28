package mainclient.fieldLessAccessible;

import main.fieldLessAccessible.FieldLessAccessible;

/**
 * Reactions:
 * - Create public2packageprivate field
 * - Create public2private field
 * - Create protected2packageprivate field
 * - Create protected2private field
 * - Initialize public2packageprivate in the class constuctor
 * - Initialize public2private in the class constuctor
 * - Initialize protected2packageprivate in the class constuctor
 * - Initialize protected2private in the class constuctor
 * - Remove super from fieldLessAccessibleClientPub2PackPrivSuperKey()
 * - Remove super from fieldLessAccessibleClientPub2PrivSuperKey()
 * - Remove super from fieldLessAccessibleClientPro2PackPrivSuperKey()
 * - Remove super from fieldLessAccessibleClientPro2PrivSuperKey
 * - Replace superPublic2Private by specific value
 * - Replace superPublic2PackagePrivate by specific value
 * - Replace superProtected2Private by specific value
 * @author Lina Ochoa
 *
 */
public class FieldLessAccessibleFASubtype extends FieldLessAccessible {
    
    private int public2packageprivate;
    private int public2private;
    private int protected2packageprivate;
    private int protected2private;
    
    public FieldLessAccessibleFASubtype() {
        public2packageprivate = 0;
        public2private = 1;
        protected2packageprivate = 2;
        protected2private = 3;
    }
    
	public int fieldLessAccessibleClientPub2ProNoSuperKey() {
		return public2protected;
	}
	
	public int fieldLessAccessibleClientPub2PackPrivNoSuperKey() {
		return public2packageprivate;
	}
	
	public int fieldLessAccessibleClientPub2PrivNoSuperKey() {
		return public2private;
	}
	
	public int fieldLessAccessibleClientPro2PackPrivNoSuperKey() {
		return protected2packageprivate;
	}
	
	public int fieldLessAccessibleClientPro2PrivNoSuperKey() {
		return protected2private;
	}
	
	public int fieldLessAccessibleClientPub2ProSuperKey() {
		return super.public2protected;
	}
	
	public int fieldLessAccessibleClientPub2PackPrivSuperKey() {
		return public2packageprivate;
	}
	
	public int fieldLessAccessibleClientPub2PrivSuperKey() {
		return public2private;
	}
	
	public int fieldLessAccessibleClientPro2PackPrivSuperKey() {
		return protected2packageprivate;
	}
	
	public int fieldLessAccessibleClientPro2PrivSuperKey() {
		return protected2private;
	}
	
	public int fieldLessAccessibleSuperPublic2Private() {
		return 0;
	}

	public int fieldLessAccessibleSuperPublic2Protected() {
		return superPublic2Protected;
	}
	
	public int fieldLessAccessibleSuperPublic2PackagePrivate() {
		return 1;
	}
	
	public int fieldLessAccessibleSuperProtected2Private() {
		return 2;
	}
}
