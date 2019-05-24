package client;

import api.A;
import api.AbstractModifierAdded;
import api.AccessModifierRemoved;
import api.DeprecatedAdded;

public class AClient {
	A a;
	AccessModifierRemoved amr;
	DeprecatedAdded da;

	public void fields() {
		hole(a.fPublicToPrivate);
		hole(a.fPublicToDefault);
		hole(a.fDeprecated);
		hole(a.fFinalModifierAdded);
		hole(a.fFinalModifierRemoved);
		hole(a.fStringToInt);
		hole(a.fStringToList);
		hole(a.fStaticModifierAdded);
		hole(a.fStaticModifierRemoved);
		hole(A.fStaticModifierRemoved);
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
		a.mStaticModifierAdded();
		a.mStaticModifierRemoved();
		A.mStaticModifierRemoved();
	}
	
	public void abstractCall() {
		AbstractModifierAdded ama = new AbstractModifierAdded();
		ama.mAbstractModifier();
	}

	void hole(Object o) { }
}
