package api;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.google.common.util.concurrent.Monitor.Guard;

public class A {
	private int fPublicToPrivate;
	private int fDefaultToPrivate;
	int fPublicToDefault;
	
	@Deprecated public int fDeprecated;
	public final String fFinalModifierAdded = "";
	public String fFinalModifierRemoved;
	static float fStaticModifierAdded;
	float fStaticModifierRemoved;
	public int fStringToInt;
	public List<String> fStringToList;
	private Guard fLimiterToGuard;
	
	public void mAccessModifierPrivateToPublic() {}
	private void mAccessModifierPublicToPrivate() {}
	private void mAccessModifierDefaultToPrivate() {}
	public void mAccessModifierDefaultToPublic() {}
	void mAccessModifierPrivateToDefault() {}
	void mAccessModifierPublicToDefault() {}
	
	public void mFinalModifierRemoved() {}
	public final void mFinalModifierAdded() {}
	private static void mStaticModifierAdded() {}
	private void mStaticModifierRemoved() {}
	@Deprecated public void mDeprecated() {}

	public void mRenamed2() {
		Map<String, String> map = new HashMap<>();
		Set entries = map.entrySet();
		Iterator iterator = entries.iterator();
		while (iterator.hasNext()) {
		    Map.Entry entry = (Map.Entry) iterator.next();
		    Object key = entry.getKey();
		    Object value = entry.getValue();
		}
	}

	public void mParameterAdded(int a, int b) {}
	public void mParameterRemoved(int a) {}
	public int mChangedType(int a) { return a; }
}
