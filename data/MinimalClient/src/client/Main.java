package client;

import p1.B;

public class Main {

	public void logic() {
		B b = new B();
		
		//This method is removed from the API
		b.m1();
		
		//The parameter list has been modified
		b.m2();
		
		//The return type has been modified
		b.m3();
		
		//The access modifier has changed
		b.m4();
		
		//The method has been renamed
		b.m5();
	}
}
