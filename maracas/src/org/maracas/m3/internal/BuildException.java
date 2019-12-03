package org.maracas.m3.internal;

/**
 * This code has been extracted from
 * https://github.com/cwi-swat/rascal-java-build-manager
 * 
 * @author Jurgen Vinju
 */
public class BuildException extends Exception {
	
	private static final long serialVersionUID = 1L;

	public BuildException(String message) {
		super(message);
	}
	
	public BuildException(String message, Throwable cause) {
		super(message, cause);
	}
}
