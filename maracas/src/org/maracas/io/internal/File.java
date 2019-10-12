package org.maracas.io.internal;

import org.rascalmpl.uri.URIResolverRegistry;

import io.usethesource.vallang.ISourceLocation;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;

public class File {

	private final IValueFactory factory;
	private URIResolverRegistry registry;

	public File(IValueFactory factory) {
		this.factory = factory;
		this.registry = URIResolverRegistry.getInstance();
	}
	
	public ISourceLocation getUserHomeDir() {
		return factory.sourceLocation(System.getProperty("user.home"));
	}
	
	public IString getLineSeparator() {
		return factory.string(System.lineSeparator());
	}
}
