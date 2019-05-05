package org.maracas.data;

import io.usethesource.vallang.IConstructor;
import io.usethesource.vallang.ISourceLocation;

public class Detection {
	enum Type {
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
		IConstructor bcType = (IConstructor) detection.get(3);

		Type type;
		switch (bcType.getName()) {
			case "changedAccessModifier": type = Type.ACCESS_MODIFIER; break;
			case "changedFinalModifier": type = Type.FINAL_MODIFIER; break;
			case "changedStaticModifier": type = Type.STATIC_MODIFIER; break;
			case "changedAbstractModifier": type = Type.ABSTRACT_MODIFIER; break;
			case "deprecated": type = Type.DEPRECATED; break;
			case "renamed": type = Type.RENAMED; break;
			case "moved": type = Type.MOVED; break;
			case "removed": type = Type.REMOVED; break;
			case "changedParamList": type = Type.PARAMS_LIST; break;
			case "changedReturnType": type = Type.RETURN_TYPE; break;
			case "changedType": type = Type.TYPE; break;
			case "changedExtends": type = Type.EXTENDS; break;
			case "changedImplements": type = Type.IMPLEMENTS; break;
			default: throw new RuntimeException("Ugh, nope.");
		}

		return new Detection(client, library, type);
	}

	public String getClientLocation() {
		return clientLocation;
	}

	public String getClienLibraryLocation() {
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
