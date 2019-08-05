package org.maracas.delta.internal;

import org.rascalmpl.values.ValueFactoryFactory;

import io.usethesource.vallang.ISetWriter;
import io.usethesource.vallang.IValueFactory;


public class Delta {
	protected ISetWriter abstractModifiers;
	protected ISetWriter accessModifiers;
	protected ISetWriter finalModifiers;
	protected ISetWriter staticModifiers;
	protected ISetWriter syntheticModifiers;
	
	private final IValueFactory valueFactory = ValueFactoryFactory.getValueFactory();
	
	public Delta() {
		this.abstractModifiers = valueFactory.setWriter();
		this.accessModifiers = valueFactory.setWriter();
		this.finalModifiers = valueFactory.setWriter();
		this.staticModifiers = valueFactory.setWriter();
		this.syntheticModifiers = valueFactory.setWriter();
	}
}
