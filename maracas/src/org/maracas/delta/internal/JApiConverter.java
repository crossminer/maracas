package org.maracas.delta.internal;

import java.io.File;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import org.rascalmpl.library.lang.java.m3.internal.M3Constants;
import org.rascalmpl.values.ValueFactoryFactory;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.ITuple;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.TypeFactory;
import japicmp.model.JApiClassType.ClassType;
import japicmp.model.JApiModifierBase;


public class JApiConverter {
	
	private final IValueFactory valueFactory = ValueFactoryFactory.getValueFactory();
	private final TypeFactory typeFactory = TypeFactory.getInstance();
	private Map<Enum, String> schemes;
	
	public JApiConverter() {
		initializeSchemes();
	}
	
	private void initializeSchemes() {
		schemes = new HashMap<Enum, String>();
		schemes.put(ClassType.ANNOTATION, "java+annotation");
		schemes.put(ClassType.CLASS, M3Constants.CLASS_SCHEME);
		schemes.put(ClassType.INTERFACE, M3Constants.INTERFACE_SCHEME);
		schemes.put(ClassType.ENUM, M3Constants.ENUM_SCHEME);
	}
	
	public <T extends Enum<T> & JApiModifierBase> IString resolve(T modifier) {
		return valueFactory.string(modifier.name());
	}

	public String getScheme(Enum e) {
		return this.schemes.get(e);
	}
	
	public <T extends IValue> ITuple createMapping(ISourceLocation location, T from, T to) {
		return valueFactory.tuple(location, from, to);
	}
	
	public ISourceLocation createLocation(String scheme, String fullyQualifiedName) {
		ISourceLocation location = null;
		try {
			String path = fullyQualifiedName.replace(".", File.separator);
			return valueFactory.sourceLocation(scheme, "", path);
		} 
		catch (URISyntaxException e) {
			throw new RuntimeException(e);
		}
	}
}
