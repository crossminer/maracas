package client;

import api.A;

public class AClient {
	A a;

	public void fields() {
		hole(a.fPublicToPrivate);
		hole(a.fPublicToDefault);
		hole(a.fDeprecated);
		hole(a.fFinalModifierAdded);
		hole(a.fFinalModifierRemoved);
		hole(a.fStringToInt);
		hole(a.fStringToList);
	}

	public void methods() {
		a.mAccessModifierPublicToDefault();
		a.mAccessModifierPublicToPrivate();
		a.mChangedType(0);
		a.mDeprecated();
		a.mFinalModifierAdded();
		a.mFinalModifierRemoved();
		a.mMoved();
		a.mParameterAdded(0);
		a.mParameterRemoved(0, 0);
		a.mRenamed();
	}

	void hole(Object o) { }
}
