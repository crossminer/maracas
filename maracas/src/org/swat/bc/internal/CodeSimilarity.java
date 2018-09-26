package org.swat.bc.internal;

import org.rascalmpl.interpreter.IEvaluatorContext;

import info.debatty.java.stringsimilarity.NormalizedLevenshtein;
import io.usethesource.vallang.IBool;
import io.usethesource.vallang.IReal;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;

public class CodeSimilarity {

	private final IValueFactory factory;
	
	public CodeSimilarity(IValueFactory factory) {
		this.factory = factory;
	}
	
	public IBool codeIsSimilar(IString snippet1, IString snippet2, IReal threshold, IEvaluatorContext eval) {
		NormalizedLevenshtein levenshtein = new NormalizedLevenshtein();
		double distance = levenshtein.distance(snippet1.getValue(), snippet2.getValue());
		eval.getStdOut().println(distance);
		return factory.bool(distance <= (1 - threshold.doubleValue()));
	}
}
