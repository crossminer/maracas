module org::maracas::m3::Core

import IO;
//import lang::java::m3::ClassPaths;
import analysis::m3::AST;
extend lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::m3::TypeSymbol;
import org::maracas::io::File;
import List;
import Node;
import Relation;
import Set;
import String;
import Type;
import ValueIO;

data M3(
	rel[loc from, loc to] invertedContainment = {},	
	rel[loc from, loc to] invertedExtends = {},
	rel[loc from, loc to] invertedImplements = {},
	rel[loc from, loc to] invertedMethodInvocation = {},
	rel[loc from, loc to] invertedFieldAccess = {},
	rel[loc from, loc to] invertedTypeDependency = {},
	rel[loc from, loc to] invertedMethodOverrides = {},
	rel[loc declaration, loc annotation] invertedAnnotations = {},
	rel[loc from, loc to] transInvertedContainment = {}
);

// extends lang::java::m3::AST::Modifier
// Could be moved to M3 creation itself
// but this is the quickest way :)
data Modifier =
	\defaultAccess();

// Just some band-aid for now
// Should it move to java::lang::m3::Core?
M3 createM3(loc jar, list[loc] classPath = []) {
	M3 model = createM3FromJar(jar, classPath = classPath);
	M3 libs = composeJavaM3(|tmp:///|, { createM3FromJar(l) | loc l <- classPath });

	// Attempt to retrieve methodOverrides across hierarchies in classpath
	rel[loc from, loc to] candidates = (model.implements + model.extends + libs.implements + libs.extends)+;
	rel[loc from, loc to] containment = domainR(model.containment + libs.containment, candidates.from + candidates.to);
	rel[loc from, loc to] methodContainment = { <c, m> | <loc c, loc m> <- containment, isMethod(m)};

	for(<loc from, loc to> <- candidates)
		model.methodOverrides += {<m, getMethodSignature(m)> | m <- methodContainment[from]}
			o {<getMethodSignature(m), m> | m <- methodContainment[to]};

	/*
		Note: M3 created from JAR/source code point to != fieldAccess/methodInvocation

		package pkg;
		class A { int i; void foo() {}  }
		class B extends A { void bar() { i = 42; foo(); }

		m = createM3FromJar gives:
			m.fieldAccess      = {<|java+method:///pkg/B/bar()|,|java+field:///pkg/B/i|>}
			m.methodInvocation = {<|java+method:///pkg/B/bar()|,|java+method:///pkg/B/foo()|>, ...}

		But |java+field:///pkg/B/i| |java+method:///pkg/B/foo()| do not exist anywhere else
		in the M3 model; they're not even contained by anything! Indeed, they're contained in A:
		    m.containment[|java+class:///pkg/A|] = {
		    	|java+field:///pkg/A/i|,
		    	|java+method:///pkg/A/foo()|
		    }
		    m.containment[|java+class:///pkg/B|] = {
		    	|java+method:///pkg/B/bar()|
		    }
	*/

	return populateInvertedRelations(model);
}

M3 createM3FromSources(loc src, list[loc] classPath = []) {
	M3 m = createM3FromDirectory(src, classPath = classPath);
	M3 libs = composeJavaM3(|tmp:///|, { createM3FromJar(l) | loc l <- classPath });

	// Just kill me
	rel[loc, loc] containment = m.containment;
	for (<from, to> <- libs.containment) {
		loc l = to;
		l.path = replaceAll(l.path, "$", "/");
		containment += <from, l>;
	}

	m = visit(m) {
		case loc l => sanitize(containment, l)
	}

	return populateInvertedRelations(m);
}

M3 populateInvertedRelations(M3 m) {
	m.invertedContainment = invert(m.containment);
	m.invertedExtends = invert(m.extends);
	m.invertedImplements = invert(m.implements);
	m.invertedMethodInvocation = invert(m.methodInvocation);
	m.invertedFieldAccess = invert(m.fieldAccess);
	m.invertedTypeDependency = invert(m.typeDependency);
	m.invertedMethodOverrides = invert(m.methodOverrides);
	m.invertedAnnotations = invert(m.annotations);
	m.transInvertedContainment = m.invertedContainment+;
	return m;
}

// Attempting to fix some discrepancies between
// source code M3s and JAR M3s
//   - Cls/Inner           => Cls$Inner
//   [- Cls/$anonymous1     => Cls$1 (brittle because order-dependent?)
//   - java+anonymousClass => java+class]
@memo
loc sanitize(rel[loc, loc] containment, loc l) {
	set[loc] enclosing = { t | t <- invert(containment)[l], isType(t) };

	if (size(enclosing) == 1) {
		loc t = getOneFrom(enclosing);
		str enclosingPath = sanitize(containment, t).path;

		if (isType(l))
			l.path = "<enclosingPath>$<l.file>";
		else
			l.path = "<enclosingPath>/<l.file>";
	}

	return l;
}

M3 readBinaryM3(loc m3)
	= readBinaryValueFile(#M3, m3);

set[value] getM3Set(loc elem, map[loc, set[value]] m) 
	= (elem in m) ? m[elem] : {};
	
list[value] getM3SortValue(loc elem, map[loc, set[value]] m) 
	= (elem in m) ? sort(m[elem]) : [];

str getM3SortString(loc elem, map[loc, set[value]] m) 
	= toString(getM3SortValue(elem, m));

loc getNonCUContainer(loc elem, M3 m) {
	invCont = invert(m.containment);
	cont = getOneFrom(invCont[elem]);
	
	if (isCompilationUnit(cont)) {
		pkg = invCont[cont];
		cont = (pkg != {}) ? getOneFrom(pkg) : cont;
	}
	else {
		cont = getOneFrom(invCont[elem]);
	}
	
	return cont;
}

loc getNonCUChild(loc elem, M3 m) {
	if (isCompilationUnit(elem)) {
		child = m.containment[elem];
		elem = (child != {}) ? getOneFrom(child) : elem;
	}
	return elem;
}

loc parentType(M3 m, loc elem) {
	list[loc] containers = [];
	
	if (isMethod(elem) || isField(elem)) {
		containers = toList(m.invertedContainment[elem]);
	}
	else if (isNestedType(elem)) {
		outer = getOuterType(elem, m);
		containers = (outer == unknownSource) ? [] : [ outer ];
	}
	else {
		containers = sort(m.transInvertedContainment[elem], isLongerPath);
	}
	
	if (p <- containers, isType(p)) {
		return p;
	}
	return unknownSource;
}

private bool isLongerPath(loc a, loc b) = size(a.path) > size(b.path);

set[loc] fields(set[loc] locs)       = { e | e <- locs, isField(e) };
set[loc] methods(set[loc] locs)      = { e | e <- locs, isMethod(e) };
set[loc] constructors(set[loc] locs) = { e | e <- locs, isConstructor(e) };
set[loc] classes(set[loc] locs)      = { e | e <- locs, isClass(e) };
set[loc] interfaces(set[loc] locs)   = { e | e <- locs, isInterface(e) };
set[loc] types(set[loc] locs)        = { e | e <- locs, isType(e) };

// TODO: consider moving this function to Rascal module lang::java::m3::Core
bool isType(loc entity) = isClass(entity) || isInterface(entity);
bool isAPIEntity(loc entity) = isType(entity) || isMethod(entity) || isField(entity);
bool isKnown(loc elem) = elem != unknownSource;
bool isAnonymousClass(loc entity) = entity.scheme == "java+anonymousClass";
bool isNestedType(loc entity) = isType(entity) && contains(entity.file, "$");
 	
bool isTargetMemberExclInterface(loc elem)
	= isClass(elem)
	|| isMethod(elem)
	|| isField(elem);

bool isTargetMember(loc elem)
	= isTargetMemberExclInterface(elem)
	|| isInterface(elem);

@memo
M3 createM3(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	//M3 m = (project.scheme == "jar" || project.extension == "jar") ? createM3FromJar(project) : m3FromFolder(project);
	M3 m = createM3FromJar(project);
	return fillDefaultVisibility(filterAnonymousClasses(m));
}

M3 m3FromFolder(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	if ((existFileWithName(project, "pom.xml") 
		|| existFileWithName(project, "MANIFEST.MF"))
		&& existFileWithExtension(project, "java")) {
		
		// This step seems to take too long
		classPath = projectClassPath(project, mvnExec);
		files = fetchFilesByExtension(project, "java");
		return createM3FromFiles(project,
			files,
			sourcePath=[project],
			classPath=classPath);
	}
	else {
		return createM3FromDirectory(project);
	}
}

private list[loc] projectClassPath(loc project, loc mvnExec) {
	//classPaths = getClassPath(project, mavenExecutable=mvnExec);
	//return [ *classPaths[cp] | cp <- classPaths ];
	return [];
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

str sourceCode(loc srcDirectory, loc logical) {
	if (logical == |unknown:///|)
		return "";

	if (isDirectory(srcDirectory)) {
		M3 sourcesM3 = createM3FromDirectoryCached(srcDirectory);
		loc sourceLoc = jarLocToSourceLoc(logical);
		set[loc] found = sourcesM3.declarations[sourceLoc];

		if (size(found) > 0) {
			loc ret = getOneFrom(found);

			if (isField(logical)) {
				ret.offset = ret.offset - ret.begin.column;
				ret.length = ret.length + ret.begin.column;
			}

			return readFile(ret);
		}
		else
			return "";
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
		bool (value v1, value v2) {
			return isAnonymousClass(v1) && isAnonymousClass(v2);
		});

private bool isAnonymousClass (value v) {
	if (loc l := v)
		return /\$[0-9]+/ !:= l.uri;
	return true;
}

M3 filterM3(M3 m, set[loc] elems) 
	= filterM3(m, 
		bool (value v1, value v2) {
			return v1 in elems || v2 in elems;
		});

/**
 * Filters out all tuples <a, b> from every relation
 * of the M3 model 'm' where neither 'a' nor 'b' are in
 * the 'elems' set. 
 */
M3 filterXM3(M3 m, set[loc] elems) 
	= filterM3(m, 
		bool (value v1, value v2) {
			return v1 notin elems && v2 notin elems;
		});

/**
 * Filters out all tuples <a, b> from every relation
 * of the M3 model 'm' where neither 'a' nor 'b' are in
 * the 'elems' set. 
 */
M3 filterXM3WithExcpetions(M3 m, set[loc] elems, set[loc] excep) 
	= filterM3(m,
		bool(value v1, value v2) {
			if (v1 notin elems && v2 in elems) {
				return v1 in excep;
			}
			else if (v2 notin elems && v1 in elems) {
				return v2 in excep;
			}
			else {
				return v1 notin elems && v2 notin elems;
			}
		});

/**
 * Filter out all tuples <a, b> from every relation
 * of the M3 model 'm' for which predicate(a, b)
 * does not hold
 */
M3 filterM3(M3 m, bool (value v1, value v2) predicate) {
	m3Filtered = m3(m.id);

	map[str, value] kws = getKeywordParameters(m);
	for (str relName <- kws) {
		value v = kws[relName];

		if (rel[value, value] relation := v)
			kws[relName] = { <a, b> | <a, b> <- relation, predicate(a, b) };
	};

	return setKeywordParameters(m3Filtered, kws);
} 

// TODO: this is not working with parameters
str packag(loc elem) {
	str scheme = elem.scheme;
	
	if (elem == unknownSource) {
		return "";
	}
	if (scheme == "java+method" || scheme == "java+constructor" || scheme == "java+field") {
		return (/<pkg: [a-zA-Z0-9.$\/]+><rest:\/[a-zA-Z0-9.$\/]*\/[a-zA-Z0-9.$\/(),]*$>/ := elem.path) ? pkg : ""; 
	}
	if (scheme == "java+class" || scheme == "java+interface"
		|| scheme == "java+enum" || scheme == "java+annotation") {
		return (/<pkg: [a-zA-Z0-9.$\/]+><rest:\/[a-zA-Z0-9.$\/]*$>/ := elem.path) ? pkg : "";
	}
	throw "The scheme of <elem> is not supported.";
}

loc getMethod(loc param) { 
	meth = (isParameter(param)) ? |java+method:///| + substring(param.path, 0, findLast(param.path, "/")) : unknownSource;
	if (/[a-zA-Z0-9.$\/]\/+<typ:[a-zA-Z0-9.$]+>\/<name:[a-zA-Z0-9.$]+>\([a-zA-Z0-9.$,]*\)$/ := meth.path
		&& typ == name) {
		meth.scheme = "java+constructor";
	
	}
	return meth;
}

set[loc] methodDeclarations(M3 m, loc class) 
	= { c | c <- m.containment[class], isMethod(c) };

set[loc] methodsWhithoutDefinition(M3 m, loc class) {
	set[loc] children = m.containment[class];
	return { c | c <- children, isMethod(c), m.declarations[c] != {} };
}

str methodQualName(loc m) {
	if (isMethod(m)) {
		return (/<mPath: [a-zA-Z0-9.$\/]+>(<mParams: [a-zA-Z0-9.$\/]*>)/ := m.path) ? mPath : "";
	}
	else {
		throw "Cannot get a method qualified name from <m>.";
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

str memberName(loc m) {
	if(isMethod(m)) {
		return memberName(methodQualName(m));
	}
	else {
		return memberName(m.path);
	}
}

private str memberName(str path) 
	= substring(path, (findLast(path, "/") + 1));
	
bool sameNames(loc n1, loc n2, str (loc) fun) = fun(n1) == fun(n2);
bool sameMethodQualName(loc m1, loc m2) = sameNames(m1, m2, methodQualName);
bool sameMethodSignature(loc m1, loc m2) = sameNames(m1, m2, methodSignature);
bool sameFieldName(loc f1, loc f2) = sameNames(f1, f2, memberName);
bool samePackage(loc e1, loc e2) = sameNames(e1, e2, packag);
 
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
	if (isField(elem)) {
		return fieldDeclaration(elem, m);
	}	
	throw "<elem> is not part of the scoped members.";
}

str typeDeclaration(loc typ, M3 m) {
	if (isType(typ)) {
		list[Modifier] modifiers = sort(m.modifiers[typ]);
		str name = memberName(typ);
		set[loc] super = m.extends[typ];
		list[loc] interfaces = sort(m.implements[typ]);
		
		return "<modifiers> <name> <super> <interfaces>";
	}
	else {
		throw "Cannot compute a type declaration from <typ>";
	}
}

str methodDeclaration(loc meth, M3 m) {
	if (isMethod(meth)) {
		list[Modifier] modifiers = sort(m.modifiers[meth]);
		TypeSymbol methType = getOneFrom(m.types[meth]);
		TypeSymbol returnType = methodReturnType(methType);
		str signature = methodSignature(meth);
		
		return "<modifiers> <returnType> <signature>";
	}
	else {
		throw "Cannot compute a method declaration from <meth>";
	}
}

str fieldDeclaration(loc field, M3 m) {
	if (isField(field)) {
		list[Modifier] modifiers = sort(m.modifiers[field]);
		set[TypeSymbol] fieldType = m.types[field];
		str name = memberName(field);
		
		return "<modifiers> <fieldType> <name>";
	}
	else {
		throw "Cannot compute a field declaration from <field>";
	}
}

bool isDeclared(loc logical, M3 m) 
	= m.declarations[logical] != {};

set[Modifier] getStaticModifier(loc logical, M3 m) 
	= getModifier(logical, m, { \static() });

set[Modifier] getAccessModifier(loc logical, M3 m) {
	set[Modifier] accessModifs = { 
		\public(), 
		\protected(), 
		\private() };
	return getModifier(logical, m, accessModifs);
}

private set[Modifier] getModifier(loc logical, M3 m, set[Modifier] modifs)
	= m.modifiers[logical] & modifs;

bool isAbstract(loc logical, M3 m) 
	= isInterface(logical) 
	|| <logical, \abstract()> in m.modifiers;
	
@memo 
set[loc] abstractMeths(M3 m, loc class) 
	= { e | e <- elements(m, class), isMethod(e), isAbstract(class, m) };

loc getDeclaration(loc logical, M3 m) {
	set[loc] decls = m.declarations[logical];
	return (!isEmpty(decls)) ? getOneFrom(decls) : unknownSource;
}

loc getOuterType(loc nested, M3 m) {
	int index = findLast(nested.path, "$");
	str path = substring(nested.path, 0, index);
	
	loc outer = |java+class:///| + path;
	if (m.declarations[outer] != {}) {
		return outer;
	}
	
	outer = |java+interface:///| + path;
	if (m.declarations[outer] != {}) {
		return outer;
	}
	
	outer = |java+anonymousClass:///| + path;
	if (m.declarations[outer] != {}) {
		return outer;
	}
	
	return unknownSource;
}

@memo
rel[loc, loc] composeExtends(set[M3] m3s)
	= { *m.extends | M3 m <- m3s };