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

// In JAR M3s, inner classes are denoted with '$'.
// In source code M3s, inner classes are denoted either with
// '/' in uri.path, or with '.' in uri.file (e.g. param types)
// Also, type erasure; e.g. JAR=Map$Entry, source=Map.Entry%3CK,V%3E,
// and JAR=java.lang.Object, source=E
// I did not solve that yet.
loc jarLocToSourceLoc(loc l) {
	// If typedecl, replace '$' with '/' in file
	if (isType(l) || isEnum(l))
		l.file = replaceAll(l.file, "$", "/");
	// If method/field/constructor/initializer,
	// replace '$' with '/' in path and '$' with
	// '.' in file
	else if (isMethod(l) || isField(l)) {
		l.file = replaceAll(l.file, "$", ".");
		l.path = replaceAll(l.path, "$", "/");
	}

	return l;
}

@memo
M3 createM3FromDirectoryCached(loc directory) {
	return createM3FromDirectory(directory);
}

str sourceCode(loc jarLocation, loc logical) {
	if (logical == |unknown:///|)
		return "";

	loc sourcesLocation = jarLocation;
	sourcesLocation.extension = "";
	sourcesLocation.file = sourcesLocation.file + "-sources";

	if (isDirectory(sourcesLocation)) {
		M3 sourcesM3 = createM3FromDirectoryCached(sourcesLocation);
		loc sourceLoc = jarLocToSourceLoc(logical);
		set[loc] found = sourcesM3.declarations[sourceLoc];

		if (size(found) > 0)
			return readFile(getOneFrom(found));
		else
			return "Couldn\'t find source for <logical>";
	}

	return "No sources available";
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
	= filterM3(m, 
		bool (value v) {
			if (loc l := v)
				return /\$[0-9]+/ !:= l.uri;
			return true;
		},
		predicateConjunction);

M3 filterM3(M3 m, set[loc] elems) 
	= filterM3(m, 
		bool (value v) {
			return v in elems;
		},
		predicateDisjunction);

M3 filterXM3(M3 m, set[loc] elems) 
	= filterM3(m, 
		bool (value v) {
			return v notin elems;
		},
		predicateConjunction);

private bool predicateConjunction(bool a, bool b)
	= a && b;

private bool predicateDisjunction(bool a, bool b)
	= a || b;

	
/**
 * Filter out all tuples <a, b> from every relation
 * of the M3 model 'm' for which either predicate(a)
 * or predicate(b) does not hold
 */
private M3 filterM3(M3 m, bool (value v) predicate, bool (bool, bool) predicateRel) {
	m3Filtered = lang::java::m3::Core::m3(m.id);

	map[str, value] kws = getKeywordParameters(m);
	for (str relName <- kws) {
		value v = kws[relName];

		if (rel[value, value] relation := v)
			kws[relName] = { <a, b> | <a, b> <- relation, predicateRel(predicate(a), predicate(b)) };
	};

	return setKeywordParameters(m3Filtered, kws);
}