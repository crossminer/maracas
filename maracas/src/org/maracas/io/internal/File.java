package org.maracas.io.internal;

import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.rascalmpl.uri.URIResolverRegistry;

import io.usethesource.vallang.IBool;
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
	
	public IBool deleteDir(ISourceLocation loc) {
		try {
			java.io.File dir =  new java.io.File(loc.getURI());
			FileUtils.deleteDirectory(dir);
			return factory.bool(true);
		} 
		catch (IOException e) {
			return factory.bool(false);
		}
	}
}
