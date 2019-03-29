module org::maracas::bc::BreakingChangesBuilder

import Boolean;
import IO;
import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::CodeSimilarity;
import org::maracas::config::Config;
import org::maracas::diff::CodeSimilarityMatcher;
import org::maracas::diff::Matcher;
import Relation;
import Set;
import String;


@memo M3 getRemovals(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3Old, m3New]);
@memo M3 getAdditions(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3New, m3Old]);

// TODO: add config parameter
@memo
BreakingChanges createClassBC(M3 m3Old, M3 m3New) {
	id = createBCId(m3Old, m3New);
	bc = class(id);
	bc = addCoreBCs(m3Old, m3New, bc);
	return postproc(bc);
}

@memo
BreakingChanges createMethodBC(M3 m3Old, M3 m3New) {
	id = createBCId(m3Old, m3New);
	bc = method(id);
	bc.changedParamList = changedParamList(m3Old, m3New);
	bc.changedReturnType = changedReturnType(m3Old, m3New);
	bc = addCoreBCs(m3Old, m3New, bc);
	return postproc(bc);
}

@memo
BreakingChanges createFieldBC(M3 m3Old, M3 m3New) {
	id = createBCId(m3Old, m3New);
	bc = field(id);
	bc = addCoreBCs(m3Old, m3New, bc);
	return postproc(bc);
}

private Mapping[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;

private BreakingChanges addCoreBCs(M3 m3Old, M3 m3New, BreakingChanges bc) {
	bc.changedAccessModifier = changedAccessModifier(m3Old, m3New, bc);
	bc.changedFinalModifier = changedFinalModifier(m3Old, m3New, bc);
	bc.changedStaticModifier = changedStaticModifier(m3Old, m3New, bc);
	//TODO: moved
	bc.deprecated = deprecated(m3Old, m3New, bc);
	bc.removed = removed(m3Old, m3New, bc);
	bc.renamed = renamed(m3Old, m3New, bc);
	return bc;
}


/*
 * Identifying changes in access modifiers
 */
// TODO: manage package modifier.
private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, \class(_)) 
	= changedAccessModifier(m3Old, m3New, isClass);
	
private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, \method(_)) 
	= changedAccessModifier(m3Old, m3New, isMethod);
	
private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, \field(_)) 
	= changedAccessModifier(m3Old, m3New, isField);

private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, bool (loc) fun) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);
	
	accMods = {\public(), \private(), \protected()};
	newElems = {<e,m> | <e,m> <- additions.modifiers, fun(e), m in accMods};
	oldElems = {<e,m> | <e,m> <- removals.modifiers, fun(e), m in accMods};
	
	oldDomain = domain(oldElems);
	newDomain = domain(newElems);
	return {<e, <getFirstFrom(oldElems[e]), getFirstFrom(newElems[e])>> | e <- newDomain, e in oldDomain, newElems[e] != oldElems[e]};
}


/*
 * Identifying changes in final modifiers
 */
private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, \class(_)) 
	= changedFinalModifier(m3Old, m3New, isClass);
	
private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, \method(_)) 
	= changedFinalModifier(m3Old, m3New, isMethod);
	
private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, \field(_)) 
	= changedFinalModifier(m3Old, m3New, isField);
	
private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, bool (loc) fun) 
	= changedModifier(m3Old, m3New, fun, \final());


/*
 * Identifying changes in static modifiers
 */
private rel[loc, Mapping[Modifier, Modifier]] changedStaticModifier(M3 m3Old, M3 m3New, \class(_)) 
	= changedStaticModifier(m3Old, m3New, isClass);
	
private rel[loc, Mapping[Modifier, Modifier]] changedStaticModifier(M3 m3Old, M3 m3New, \method(_)) 
	= changedStaticModifier(m3Old, m3New, isMethod);
	
private rel[loc, Mapping[Modifier, Modifier]] changedStaticModifier(M3 m3Old, M3 m3New, \field(_)) 
	= changedStaticModifier(m3Old, m3New, isField);
	
private rel[loc, Mapping[Modifier, Modifier]] changedStaticModifier(M3 m3Old, M3 m3New, bool (loc) fun) 
	= changedModifier(m3Old, m3New, fun, \static());

private rel[loc, Mapping[Modifier, Modifier]] changedModifier(M3 m3Old, M3 m3New, bool (loc) fun, Modifier modifier) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);	
	return {<e, <\default(), m>> | <e,m> <- additions.modifiers, m := modifier, fun(e)}
		+ {<e, <m, \default()>> | <e,m> <- removals.modifiers, m := modifier, fun(e)};
}


/*
 * Identifying deprecated elements
 * TODO: annotations rel in M3 from source code is not working properly.  
 */
private rel[loc, Mapping[loc, loc]] deprecated(M3 m3Old, M3 m3New, BreakingChanges bc) {
	load = org::maracas::config::Config::DEP_MATCHES_LOAD in bc.config
		&& fromString(bc.config[org::maracas::config::Config::DEP_MATCHES_LOAD]);
		
	if(load) {
		url = |file://| + bc.config[org::maracas::config::Config::DEP_MATCHES_LOC];
		matches = loadMatches(url);
		return {<from, <from, to>>| <c, <from, to>> <- matches};
	}
	
	// FIXME: implement cases where we do not know the actual mappings.
	return {<e, <e, a>> | <e, a> <- m3Old.annotations, a == |java+interface:///java/lang/Deprecated|};
}

 
/*
 * Identifying removed elements
 */
private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, \class(_)) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	m3Diff = getRemovals(m3Old, m3New);	
	return {<c, <p, c>> | <p, c> <- m3Diff.containment, isPackage(p), isClass(c) || isInterface(c)};
}

private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, \method(_)) 
	= removed(m3Old, m3New, isMethod);
	
private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, \field(_)) 
	= removed(m3Old, m3New, isField);

private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Diff = getRemovals(m3Old, m3New);	
	return {<e, <p, e>> | <p, e> <- m3Diff.containment, fun(e), isClass(p) || isInterface(p)};
}


/*
 * Identifying renamed elements
 */
private rel[loc, Mapping[loc, loc]] renamed(M3 m3Old, M3 m3New, \class(_)) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	return renamed(m3Old, m3New, isClass);
}

private rel[loc, Mapping[loc, loc]] renamed(M3 m3Old, M3 m3New, \method(_)) 
	= renamed(m3Old, m3New, isMethod);

private rel[loc, Mapping[loc, loc]] renamed(M3 m3Old, M3 m3New, \field(_)) 
	= renamed(m3Old, m3New, isField);
	
private rel[loc, Mapping[loc, loc]] renamed(M3 m3Old, M3 m3New, bool (loc) fun) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);
	
	
	if (m3Old.id.extension == "jar") {
		Matcher jaccardMatcher = matcher(jaccardMatch); 
		jaccardMatcher.match(additions, removals, fun);
	}
	else {
		// TODO: return matches
		Matcher levenshteinMatcher = matcher(levenshteinMatch); 
		levenshteinMatcher.match(additions, removals, fun);
	}
	
	result = {};
	return result;
}


/*
 * Identifying changes in method parameter lists
 */
private rel[loc, Mapping[list[TypeSymbol], list[TypeSymbol]]] changedParamList(M3 m3Old, M3 m3New) 
	= changedMethodSignature(m3Old, m3New, methodParams);


/*
 * Identifying changes in method return types
 */
private rel[loc, Mapping[TypeSymbol, TypeSymbol]] changedReturnType(M3 m3Old, M3 m3New)
	= changedMethodSignature(m3Old, m3New, methodReturnType);
	
private rel[loc, Mapping[&T, &T]] changedMethodSignature(M3 m3Old, M3 m3New, &T (&U) fun) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);
	
	newMeths = {<m,t> | <m,t> <- additions.types, isMethod(m) || isConstructor(m)};
	oldMeths = {<m,t> | <m,t> <- removals.types, isMethod(m) || isConstructor(m)};
	
	result = {};
	for (<newMeth, newType> <- newMeths) {
		for (<oldMeth, oldType> <- oldMeths, sameMethodQualName(newMeth,oldMeth)) {
			newElems = fun(newType);
			oldElems = fun(oldType);
			
			if (oldElems != newElems) {
					result += <oldMeth, <oldElems, newElems>>;
			}
		}
	}
	return result;
}

private bool sameMethodQualName(loc m1, loc m2) {
	m1Name = methodQualName(m1);
	m2Name = methodQualName(m2);
	return m1Name == m2Name;
} 

private str methodQualName(loc m) = (/<mPath: [a-zA-Z0-9.$\/]+>(<mParams: [a-zA-Z0-9.$\/]*>)/ := m.path) ? mPath : "";
private str methodName(loc m) = substring(methodQualName(m), (findLast(methodQualName(m), "/") + 1));
private list[TypeSymbol] methodParams(TypeSymbol typ) = (\method(_,_,_,params) := typ) ? params : [];
private TypeSymbol methodReturnType(TypeSymbol typ) = (\method(_,_,ret,_) := typ) ? ret : \void();


//----------------------------------------------
// Postprocessing
//----------------------------------------------

private BreakingChanges postproc(BreakingChanges bc) {
	bc = postprocRenamed(bc);

	bc.changedAccessModifier = {<e, m> | <e, m> <- bc.changedAccessModifier, include(e)};
	bc.changedFinalModifier  = {<e, m> | <e, m> <- bc.changedFinalModifier,  include(e)};
	bc.changedStaticModifier = {<e, m> | <e, m> <- bc.changedStaticModifier, include(e)};
	bc.moved   = {<e, m> | <e, m> <- bc.moved,   include(e), include(m[0]), include(m[1])};
	bc.removed = {<e, m> | <e, m> <- bc.removed, include(e), include(m[0]), include(m[1])};
	bc.renamed = {<e, m> | <e, m> <- bc.renamed, include(e), include(m[0]), include(m[1])};
	//bc.changedParamList  = {<e, m> | <e, m> <- bc.changedParamList,  include(e)};
	//bc.changedReturnType = {<e, m> | <e, m> <- bc.changedReturnType, include(e)};
	//bc.changedType       = {<e, m> | <e, m> <- bc.changedType,       include(e)};

	switch (bc) {
		case \method(_) : return postprocMethodBC(bc);
		default : return bc; 
	}
}

private bool include(loc l) {
	return /org\/sonar\/api\/internal\// !:= l.uri;
}
 
private BreakingChanges postprocMethodBC(BreakingChanges bc) { 
	bc = postprocChangedParamList(bc);
	return bc;
}

private BreakingChanges postprocRenamed(BreakingChanges bc) {
	bc.removed = domainX(bc.removed, (bc.removed.elem & bc.renamed.elem));
	return bc;
}

private BreakingChanges postprocChangedParamList(BreakingChanges bc) {
	bc.removed = domainX(bc.removed, (bc.removed.elem & bc.changedParamList.elem));
	return bc;
}