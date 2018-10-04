package p1;

public class G {

	// [REFACT] Removing final and static modifiers.
	public String nonCons;
	
	// [REFACT] Adding final and static modifiers.
	public final static String cons = "CTE";
	
	// [REFACT] "remove" field has been removed.
	
	// [REFACT] Changed in field modifier (private to public).
	public boolean toPublic;
	
	// [REFACT] Changed in field modifier (public to private).
	private boolean toPrivate;
	
	// [REFACT] Adding static modifier.
	private static B bStatic;
	
	// [REFACT] Removing static modifier.
	private B bNonStatic;
}
