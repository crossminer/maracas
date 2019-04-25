package api;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class A {
	public int fPublicToPrivate;
	int fDefaultToPrivate;
	public int fPublicToDefault;
	
	public String fFinalModifier;
	static float fStaticModifier;
	public String fType;

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
