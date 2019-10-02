package org.maracas.groundtruth.internal;

import java.util.HashMap;
import java.util.Map;

class CompilationMessage {
	String path;
	int line;
	int offset;
	String message;
	Map<String, String> parameters = new HashMap<>();

	public CompilationMessage(String path, int line, int offset, String message, Map<String, String> parameters) {
		this.path = path;
		this.line = line;
		this.offset = offset;
		this.message = message;
		this.parameters = parameters;
	}

	@Override
	public String toString() {
		return new StringBuilder()
			.append("Path: " + path)
			.append(" Line: " + line)
			.append(" Offset: " + offset)
			.append(" Message: " + message)
			.append(" Params: " + parameters)
			.toString();
	}
}
