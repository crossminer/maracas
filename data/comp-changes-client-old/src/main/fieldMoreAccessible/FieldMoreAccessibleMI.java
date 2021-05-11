package main.fieldMoreAccessible;

public class FieldMoreAccessibleMI {

	private FieldMoreAccessible c;
	
	public FieldMoreAccessibleMI() {
		c = new FieldMoreAccessible();
	}
	
	public void packageprivate2private() {
		int v = c.packageprivate2private;
	}
	
	public void packageprivate2protected() {
		int v = c.packageprivate2protected;
	}
	
	public void packageprivate2public() {
		int v = c.packageprivate2public;
	}
	
	public void protected2packageprivate() {
		int v = c.protected2packageprivate;
	}
	
	public void protected2private() {
		int v = c.protected2private;
	}
	
	public void protected2public() {
		int v = c.protected2public;
	}
	
	public void public2packageprivate() {
		int v = c.public2packageprivate;
	}
	
	public void public2private() {
		int v = c.public2private;
	}
	
	public void public2protected() {
		int v = c.public2protected;
	}
	
	public void superPackagePrivate2Public() {
		int v = c.superPackagePrivate2Public;
	}
	
	public void superPackagePrivateToProtected() {
		int v = c.superPackagePrivateToProtected;
	}
	
	public void superProtected2Public() {
		int v = c.superProtected2Public;
	}
}
