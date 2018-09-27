package org.swat.math.internal;

import org.swat.math.Calculator;

public class BasicCalculator implements Calculator {

	@Override
	public int add(int n, int m) {
		return n + m;
	}

	@Override
	public int substract(int n, int m) {
		return n - m;
	}

	@Override
	public int multiply(int n, int m) {
		return n * m;
	}

	@Override
	public int divide(int n, int m) {
		return n / m;
	}

}
