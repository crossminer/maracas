module org::maracas::m3::Core

import IO;
import lang::java::m3::ClassPaths;
import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::io::File;
import Relation;
import Set;
import String;
import Type;
import ValueIO;
import Node;
import Type;

// extends lang::java::m3::AST::Modifier
// Could be moved to M3 creation itself
// but this is the quickest way :)
data Modifier =
	\defaultAccess();

// TODO: consider moving this function to Rascal module lang::java::m3::Core
bool isType(loc entity) = isClass(entity) || isInterface(entity);

@memo
M3 m3(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	M3 m = (project.scheme == "jar" || project.extension == "jar") ? createM3FromJar(project) : m3FromFolder(project);

	return fillDefaultVisibility(filterAnonymousClasses(m));
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

@memo
M3 createM3FromDirectoryCached(loc directory) {
	return createM3FromDirectory(directory);
}

str sourceCode(loc jarLocation, loc logical) {
	loc sourcesLocation = jarLocation;
	sourcesLocation.extension = "";
	sourcesLocation.file = sourcesLocation.file + "-sources";

	if (isDirectory(sourcesLocation)) {
		M3 sourcesM3 = createM3FromDirectoryCached(sourcesLocation);
		set[loc] found = sourcesM3.declarations[logical];

		if (size(found) > 0)
			return readFile(getOneFrom(sourcesM3.declarations[logical]));
	}

	return "";
}

str javadoc(loc jarLocation, loc logical) {
	loc sourcesLocation = jarLocation;
	sourcesLocation.extension = "";
	sourcesLocation.file = sourcesLocation.file + "-sources";

	if (isDirectory(sourcesLocation)) {
		M3 sourcesM3 = createM3FromDirectoryCached(sourcesLocation);
		set[str] javadocs = { readFile(l) | l <- sourcesM3.documentation[logical] };
		return ("" | it + "<doc>" | doc <- javadocs);
	}

	return "";
}

list[str] javadocLinks(loc jarLocation, loc logical) {
	str doc = replaceAll(javadoc(jarLocation, logical), "\n", "");

	if (!isEmpty(doc))
		return [ trim(replaceAll(link, "*", "")) | /\{@link <link: [^}]*>\}/ := doc ];
	else
		return [];
}

M3 fillDefaultVisibility(M3 m3) {
	accMods = { \defaultAccess(), \public(), \private(), \protected() };

	// Concise version, *extremely* slow (?)
	//m3.modifiers += { <elem, \defaultAccess()> | elem <- domain(m3.declarations),
	//					(isType(elem) || isMethod(elem) || isField(elem))
	//					&& isEmpty(m3.modifiers[elem] & accMods) }; 

	m3.modifiers += { <elem, \defaultAccess()> | elem <- domain(m3.declarations),
						(isType(elem) || isMethod(elem) || isField(elem))
						&& <elem, \public()> notin m3.modifiers
						&& <elem, \protected()> notin m3.modifiers
						&& <elem, \private()> notin m3.modifiers };

	return m3;
}

M3 filterAnonymousClasses(M3 m)
	= filterM3(m, bool (value v) {
		if (loc l := v)
			return /\$[0-9]+/ !:= l.uri;
		return true;
	});

/**
 * Filter out all tuples <a, b> from every relation
 * of the M3 model 'm' for which either predicate(a)
 * or predicate(b) does not hold
 */
private M3 filterM3(M3 m, bool (value v) predicate) {
	m3Filtered = lang::java::m3::Core::m3(m.id);

	map[str, value] kws = getKeywordParameters(m);
	for (str relName <- kws) {
		value v = kws[relName];

		if (rel[value, value] relation := v)
			kws[relName] = { <a, b> | <a, b> <- relation, predicate(a) && predicate(b) };
	};

	return setKeywordParameters(m3Filtered, kws);
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