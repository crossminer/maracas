package main;

import java.util.ArrayList;

public class MethodReturnTypeChangedImp implements IMethodReturnTypeChanged{

	@Override
	public ArrayList methodReturnTypeChangedList() {
		return new ArrayList();
	}

	@Override
	public long methodReturnTypeChangedNumeric() {
		return 1;
	}

}
