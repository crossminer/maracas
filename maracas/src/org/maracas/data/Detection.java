package org.maracas.data;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.ISourceLocation;

public class Detection {
	public enum Type {
		ACCESS_MODIFIER, FINAL_MODIFIER, STATIC_MODIFIER, ABSTRACT_MODIFIER, DEPRECATED, RENAMED, MOVED, REMOVED,
		PARAMS_LIST, RETURN_TYPE, TYPE, EXTENDS, IMPLEMENTS
	}

	private final String clientLocation;
	private final String libraryLocation;
	private final Type type;

	public Detection(String client, String library, Type type) {
		this.clientLocation = client;
		this.libraryLocation = library;
		this.type = type;
	}

	public static Detection fromRascalDetection(IConstructor detection) {
		// detection(elem, used, mapping, typ)
		String client = ((ISourceLocation) detection.get(0)).toString();
		String library = ((ISourceLocation) detection.get(1)).toString();
		IConstructor deltaType = (IConstructor) detection.get(3);

		Type type;
		switch (deltaType.getName()) {
			case "accessModifiers": type = Type.ACCESS_MODIFIER; break;
			case "finalModifiers": type = Type.FINAL_MODIFIER; break;
			case "staticModifiers": type = Type.STATIC_MODIFIER; break;
			case "abstractModifiers": type = Type.ABSTRACT_MODIFIER; break;
			case "paramLists": type = Type.PARAMS_LIST; break;
			case "types": type = Type.TYPE; break;
			case "extends": type = Type.EXTENDS; break;
			case "implements": type = Type.IMPLEMENTS; break;
			case "deprecated": type = Type.DEPRECATED; break;
			case "renamed": type = Type.RENAMED; break;
			case "moved": type = Type.MOVED; break;
			case "removed": type = Type.REMOVED; break;
			default: throw new RuntimeException("Ugh, nope.");
		}

		return new Detection(client, library, type);
	}

	public String getClientLocation() {
		return clientLocation;
	}

	public String getLibraryLocation() {
		return libraryLocation;
	}

	public Type getType() {
		return type;
	}

	@Override
	public String toString() {
		return String.format("%s uses %s [%s]", clientLocation, libraryLocation, type);
	}
}
