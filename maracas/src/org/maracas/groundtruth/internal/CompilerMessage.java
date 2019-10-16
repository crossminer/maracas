package org.maracas.groundtruth.internal;

import java.util.HashMap;
import java.util.Map;

class CompilerMessage {
	String path;
	int line;
	int column;
	String message;
	Map<String, String> parameters = new HashMap<>();

	public CompilerMessage(String path, int line, int column, String message, Map<String, String> parameters) {
		this.path = path;
		this.line = line;
		this.column = column;
		this.message = message;
		this.parameters = parameters;
	}

	@Override
	public String toString() {
		return new StringBuilder()
			.append("Path: " + path)
			.append(" Line: " + line)
			.append(" Offset: " + column)
			.append(" Message: " + message)
			.append(" Params: " + parameters)
			.toString();
	}
}
