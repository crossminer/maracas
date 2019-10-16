package org.maracas.groundtruth.internal;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IMap;
import io.usethesource.vallang.IMapWriter;
import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.Type;
import io.usethesource.vallang.type.TypeFactory;
import io.usethesource.vallang.type.TypeStore;

public class CompilerMessageToRascal {

	private IValueFactory vf;
	private TypeStore ts;
	private TypeFactory tf;
	
	private Type compilerMessageADT;
	private Type compilerMessageCons;
	
	public CompilerMessageToRascal(IValueFactory vf) {
		this.vf = vf;
		this.ts = new TypeStore();
		this.tf = TypeFactory.getInstance();
		
		this.compilerMessageADT = tf.abstractDataType(ts, "CompilerMessage");
		this.compilerMessageCons = tf.constructor(ts, compilerMessageADT, "message", tf.sourceLocationType(), 
				tf.integerType(), tf.integerType(), tf.stringType(), tf.mapType(tf.stringType(),  tf.stringType()));
	}
	
	public IConstructor buildCompilerMessage(ISourceLocation path, IInteger line, IInteger column,
			IString message, IMap params) {
		return vf.constructor(compilerMessageCons, path, line, column, message, params);
	}
	
	public IConstructor javaToRascal(CompilerMessage msg) {
		ISourceLocation path = vf.sourceLocation(msg.path);
		IInteger line = vf.integer(msg.line);
		IInteger column = vf.integer(msg.column);
		IString message = vf.string(msg.message);
		IMapWriter params = vf.mapWriter();

		for (String k : msg.parameters.keySet()) {
			params.put(vf.string(k), vf.string(msg.parameters.get(k)));
		}
		
		return buildCompilerMessage(path, line, column, message, params.done());
	}
}
