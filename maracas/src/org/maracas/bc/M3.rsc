module org::maracas::bc::M3

import IO;
import lang::java::m3::ClassPaths;
import lang::java::m3::Core;
import org::maracas::io::File;
import Relation;
import Set;
import String;
import Type;
import ValueIO;


@memo
M3 m3(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	if (project.scheme == "jar" || project.extension == "jar") {
		return createM3FromJar(project);
	}
	else {
		return m3FromFolder(project);
	}
}

M3 m3FromFolder(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	if (existFileWithName(project, "pom.xml") 
		|| existFileWithName(project, "MANIFEST.MF")) {
		
		// This step seems to take too long
		classPath = projectClassPath(project, mvnExec);
		
		return createM3FromFiles(project,
			fetchFilesByExtension(project, "java"),
			sourcePath=[project],
			classPath=classPath);
	}
	else {
		return createM3FromDirectory(project);
	}
}

private list[loc] projectClassPath(loc project, loc mvnExec) {
	classPaths = getClassPath(project, mavenExecutable=mvnExec);
	return [ *classPaths[cp] | cp <- classPaths ];
}

private set[loc] fetchFilesByExtension(loc directory, str extension) {
	set[loc] files = {};
	if (isDirectory(directory)) { 
		for (f <- directory.ls) {
			if (isDirectory(f)) {
				files += fetchFilesByExtension(f, extension);
			}
			if (isFile(f) && f.extension == "<extension>") {
				files += f;
			}
		}
	}
	return files;
}

M3 filterM3(M3 m, set[loc] elems) 
	= filterM3(m, elems, filterElements);

M3 filterXM3(M3 m, set[loc] elems) 
	= filterM3(m, elems, filterXElements);

private M3 filterM3(M3 m, set[loc] elems, rel[&T, &R] (rel[&T, &R], set[&S]) fun) {
	m3Filtered = m3(m.id);

	// Core M3 relations
	m3Filtered.declarations 	= fun(m.declarations, elems);
	m3Filtered.types 			= fun(m.types, elems);
	m3Filtered.uses 			= fun(m.uses, elems);
	m3Filtered.containment 		= fun(m.containment, elems);
	m3Filtered.names 			= fun(m.names, elems);
	m3Filtered.documentation 	= fun(m.documentation, elems);
	m3Filtered.modifiers 		= fun(m.modifiers, elems);

	// Java M3 relations
	m3Filtered.extends 			= fun(m.extends, elems);
	m3Filtered.implements 		= fun(m.implements, elems);
	m3Filtered.methodInvocation = fun(m.methodInvocation, elems);
	m3Filtered.fieldAccess 		= fun(m.fieldAccess, elems);
	m3Filtered.typeDependency 	= fun(m.typeDependency, elems);
	m3Filtered.methodOverrides 	= fun(m.methodOverrides, elems);
	m3Filtered.annotations 		= fun(m.annotations, elems);
	
	return m3Filtered;
}
	
private rel[&T, &R] filterElements(rel[&T, &R] relToFilter, set[&S] elems) {
	if (relToFilter != {} && elems != {}) {
		result = {};
		elemRel = getOneFrom(relToFilter);
		elemSet = getOneFrom(elems);
		
		if (<first, second> := elemRel) {
			result += (typeOf(first) == typeOf(elemSet)) ? domainR(relToFilter, elems) : {};
			result += (typeOf(second) == typeOf(elemSet)) ? rangeR(relToFilter, elems) : {};
		}
		return result;
	}
	return relToFilter;
}

private rel[&T, &R] filterXElements(rel[&T, &R] relToFilter, set[&S] elems)
	= relToFilter - filterElements(relToFilter, elems);