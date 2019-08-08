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
	private TypeStore typeStore;
	private final IValueFactory valueFactory;
	private JApiCmpToRascal japicmpToRascal;
	
	public JApiCmp(IValueFactory valueFactory) {
		this.valueFactory = valueFactory;
	}
	
	public IList compareJars(ISourceLocation oldJar, ISourceLocation newJar, IString oldVersion, IString newVersion, IEvaluatorContext eval) {
		initializeJApiCmpTypeStore(eval);
		initializeJApiCmpToRascal();
		return japicmpToRascal.compare(oldJar, newJar, oldVersion, newVersion);
	}
	
	private void initializeJApiCmpTypeStore(IEvaluatorContext eval) {
		ModuleEnvironment japicModule = eval.getHeap().getModule("org::maracas::delta::JApiCmp");
		ModuleEnvironment m3Module = eval.getHeap().getModule("lang::java::m3::AST");
		
		this.typeStore = new TypeStore();
		this.typeStore.extendStore(japicModule.getStore());
		this.typeStore.extendStore(m3Module.getStore());
	}
	
	private void initializeJApiCmpToRascal() {
		this.japicmpToRascal = new JApiCmpToRascal(typeStore, valueFactory);
	}
}
