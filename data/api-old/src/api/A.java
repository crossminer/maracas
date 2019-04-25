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
	float fStaticModifierAdded;
	static float fStaticModifierRemoved;
	public String fStringToInt;
	public String fStringToList;
	private RateLimiter fLimiterToGuard;

	private void mAccessModifierPrivateToPublic() {}
	public void mAccessModifierPublicToPrivate() {}
	void mAccessModifierDefaultToPrivate() {}
	void mAccessModifierDefaultToPublic() {}
	private void mAccessModifierPrivateToDefault() {}
	public void mAccessModifierPublicToDefault() {}
	
	public final void mFinalModifier() {}
	private static void mStaticModifier() {}
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

	public void mParamList(int a, int b) {}
	public String mReturnType(int a) { return ""; }
}
