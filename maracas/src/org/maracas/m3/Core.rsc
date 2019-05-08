module org::maracas::m3::Core

import IO;
import lang::java::m3::ClassPaths;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::m3::TypeSymbol;
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

str methodQualName(loc m) {
	if (isMethod(m)) {
		return (/<mPath: [a-zA-Z0-9.$\/]+>(<mParams: [a-zA-Z0-9.$\/]*>)/ := m.path) ? mPath : "";
	}
	else {
		throw "Cannot get a method qualified name from <m>.";
	}
}

bool sameMethodQualName(loc m1, loc m2) {
	if (isMethod(m1) && isMethod(m2)) {
		m1Name = methodQualName(m1);
		m2Name = methodQualName(m2);
		return m1Name == m2Name;
	}
	else {
		throw "Cannot compare <m1> and <m2>. Wrong scheme(s).";
	}
}

str methodName(loc m) {
	if (isMethod(m)) {
		return substring(methodQualName(m), (findLast(methodQualName(m), "/") + 1));
	}
	else {
		throw "Cannot get a method name from <m>.";
	}
}

str methodSignature(loc m) {
	if (isMethod(m)) {
		return substring(m.path, (findLast(m.path, "/") + 1));
	}
	else {
		throw "Cannot get a method signature from <m>.";
	}
}

list[TypeSymbol] methodParams(TypeSymbol typ) 
	= (\method(_,_,_,params) := typ) ? params : [];
	
TypeSymbol methodReturnType(TypeSymbol typ) 
	= (\method(_,_,ret,_) := typ) ? ret : TypeSymbol::\void();

str memberDeclaration(loc elem, M3 m) {
	if (isType(elem)) {
		return typeDeclaration(elem, m);
	}
	if (isMethod(elem)) {
		return methodDeclaration(elem, m);
	}
	if (isField(elem, m)) {
		return fieldDeclaration(elem, m);
	}	
	throw "<elem> is not part of the scoped members.";
}

str typeDeclaration(loc typ, M3 m) {
	if (isType(typ)) {
		modifiers = sort(m.modifiers[typ]);
		name = getOneFrom(m.names[typ]);
		super = getOneFrom(m.extends[typ]);
		interfaces = m.implements[typ];
		
		return "<modifiers> <name> <super> <interfaces>";
	}
	else {
		throw "Cannot compute a type declaration from <typ>";
	}
}

str methodDeclaration(loc meth, M3 m) {
	if (isMethod(m)) {
		modifiers = sort(m.modifiers[meth]);
		methType = getOneFrom(m.types[meth]);
		returnType = methodReturnType(methType);
		signature = methodSignature(meth);
		
		return "<modifiers> <returnType> <signature>";
	}
	else {
		throw "Cannot compute a method declaration from <meth>";
	}
}

str fieldDeclaration(loc field, M3 m) {
	if (isField(field)) {
		modifiers = sort(m.modifiers[field]);
		fieldType = getOneFrom(m.types[field]);
		name = getOneFrom(m.names[field]);
		
		return "<modifiers> <fieldType> <name>";
	}
	else {
		throw "Cannot compute a field declaration from <field>";
	}
}