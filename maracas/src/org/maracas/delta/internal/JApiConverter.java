package org.maracas.delta.internal;

import java.io.File;
import java.net.URISyntaxException;

import org.rascalmpl.values.ValueFactoryFactory;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.ITuple;
import io.usethesource.vallang.IValue;
import io.usethesource.vallang.IValueFactory;
import io.usethesource.vallang.type.TypeFactory;
import japicmp.model.JApiModifierBase;


public class JApiConverter {
	
	private final IValueFactory valueFactory = ValueFactoryFactory.getValueFactory();
	private final TypeFactory typeFactory = TypeFactory.getInstance();
	
	public <T extends Enum<T> & JApiModifierBase> IString resolve(T modifier) {
		return valueFactory.string(modifier.name());
	}
	
	public <T extends IValue> ITuple createMapping(ISourceLocation location, T from, T to) {
		return valueFactory.tuple(location, from, to);
	}
	
	public ISourceLocation createLocation(String scheme, String fullyQualifiedName) {
		ISourceLocation location = null;
		try {
			String path = fullyQualifiedName.replace(".", File.separator);
			location = valueFactory.sourceLocation(scheme, "", path);
		} 
		catch (URISyntaxException e) {
			e.printStackTrace();
		}
		
		return location;
	}
}
