package org.maracas.delta.internal;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.env.ModuleEnvironment;
import org.rascalmpl.values.ValueFactoryFactory;

import io.usethesource.vallang.IList;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.TypeStore;

public class JApiCmp {
	
	private final TypeStore typeStore;
	private final IValueFactory valueFactory;
	private IEvaluatorContext eval;
	private JApiCmpToRascal japicmpToRascal;
	
	public JApiCmp(IValueFactory valueFactory) {
		this.typeStore = new TypeStore();
		this.valueFactory = valueFactory;
	}
	
	public IList compareJars(ISourceLocation oldJar, ISourceLocation newJar, IString oldVersion, IString newVersion, IEvaluatorContext eval) {
		initializeJApiCmpToRascal(eval);
		return japicmpToRascal.compare(oldJar, newJar, oldVersion, newVersion);
	}
	
	private void initializeJApiCmpToRascal(IEvaluatorContext eval) {
		this.eval = eval;
		this.japicmpToRascal = new JApiCmpToRascal(typeStore, valueFactory, eval);
	}
}
