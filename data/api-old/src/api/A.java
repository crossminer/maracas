package api;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import com.google.common.util.concurrent.RateLimiter;

public class A {
	public int fPublicToPrivate;
	int fDefaultToPrivate;
	public int fPublicToDefault;
	
	public int fDeprecated;
	public String fFinalModifierAdded;
	public final String fFinalModifierRemoved = "";
	public float fStaticModifierAdded;
	public static float fStaticModifierRemoved;
	public String fStringToInt;
	public String fStringToList;
	private RateLimiter fLimiterToGuard;

	private void mAccessModifierPrivateToPublic() {}
	public void mAccessModifierPublicToPrivate() {}
	void mAccessModifierDefaultToPrivate() {}
	void mAccessModifierDefaultToPublic() {}
	private void mAccessModifierPrivateToDefault() {}
	public void mAccessModifierPublicToDefault() {}
	
	public final void mFinalModifierRemoved() {}
	public void mFinalModifierAdded() {}
	public void mStaticModifierAdded() {}
	public static void mStaticModifierRemoved() {}
	public void mDeprecated() {}

	public int mMoved() { return 0; }
	private float mRemoved() { return 0.f; }

	public void mRenamed() {
		Map<String, String> map = new HashMap<>();
		Set entries = map.entrySet();
		Iterator iterator = entries.iterator();
		while (iterator.hasNext()) {
		    Map.Entry entry = (Map.Entry) iterator.next();
		    Object key = entry.getKey();
		    Object value = entry.getValue();
		}
	}

	public void mParameterAdded(int a) {}
	public void mParameterRemoved(int a, int b) {}
	public String mChangedType(int a) { return ""; }
}
