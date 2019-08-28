package mainclient;

import main.MethodNowFinal;

public class MethodNowFinalExt extends MethodNowFinal {

	@Override
	public int methodNowFinal() {
		return 1;
	}
	
	public int methodNowFinalClient() {
		return super.methodNowFinal();
	}
}
