module org::maracas::bc::BreakingChangesBuilder

import IO;
import Boolean;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::m3::TypeSymbol;
import org::maracas::bc::BreakingChanges;
import org::maracas::config::Config;
import org::maracas::diff::CodeSimilarityMatcher;
import org::maracas::diff::Matcher;
import org::maracas::io::properties::IO;
import Relation;
import Set;
import String;
import Type;


@memo M3 getRemovals(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3Old, m3New]);
@memo M3 getAdditions(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3New, m3Old]);

@memo
BreakingChanges createClassBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	id = createBCId(m3Old, m3New);
	bc = class(id);
	bc = addCoreBCs(m3Old, m3New, bc, optionsFile);
	return postproc(bc);
}

@memo
BreakingChanges createMethodBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	id = createBCId(m3Old, m3New);
	bc = method(id);
	bc.changedParamList = changedParamList(m3Old, m3New);
	bc.changedReturnType = changedReturnType(m3Old, m3New);
	bc = addCoreBCs(m3Old, m3New, bc, optionsFile);
	return postproc(bc); 
}

@memo
BreakingChanges createFieldBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	id = createBCId(m3Old, m3New);
	bc = field(id);
	bc = addCoreBCs(m3Old, m3New, bc, optionsFile);
	return postproc(bc);
}

private Mapping[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;

private BreakingChanges addCoreBCs(M3 m3Old, M3 m3New, BreakingChanges bc, loc optionsFile) {
	bc.options = readProperties(optionsFile);
	
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
	elemsNew = {<elem, modif> | <elem, modif> <- additions.modifiers, fun(elem), modif in accMods};
	elemsOld = {<elem, modif> | <elem, modif> <- removals.modifiers, fun(elem), modif in accMods};
	
	domainOld = domain(elemsOld);
	domainNew = domain(elemsNew);
	return {<elem, <getFirstFrom(elemsOld[elem]), getFirstFrom(elemsNew[elem])>> 
		| elem <- domainNew, elem in domainOld, elemsNew[elem] != elemsOld[elem]};
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
	return {<elem, <\default(), modif>> | <elem, modif> <- additions.modifiers, modif := modifier, fun(elem)}
		+ {<elem, <modif, \default()>> | <elem, modif> <- removals.modifiers, modif := modifier, fun(elem)};
}


/*
 * Identifying deprecated elements. It only considers deprecated elements
 * introduced in m3New.
 * TODO: annotations rel in M3 from source code is not working properly.  
 */
private rel[loc, Mapping[loc, loc]] deprecated(M3 m3Old, M3 m3New, BreakingChanges bc) {
	switch (bc) {
		case \class(_) : {
			m3Old.containment = m3Old.containment+;
			m3New.containment = m3New.containment+;
			return deprecated(m3Old, m3New, isType, bc.options);
		}
		case \method(_) : return deprecated(m3Old, m3New, isMethod, bc.options);
		case \field(_) : return deprecated(m3Old, m3New, isField, bc.options);
		default : return {};
	}
}

private rel[loc, Mapping[loc, loc]] deprecated(M3 m3Old, M3 m3New, bool (loc) fun, map[str,str] options) {
	load = DEP_MATCHES_LOAD in options && fromString(options[DEP_MATCHES_LOAD]);
	
	// TODO: check that we only load matches from a certain kind (i.e. class, method, field)	
	if (load) {
		url = |file://| + options[DEP_MATCHES_LOC];
		matches = loadMatches(url);
		return {<from, <from, to>>| <from, to, conf> <- matches};
	}
	
	additions = getAdditions(m3Old, m3New);
	elemsDeprecated = {e | <e, a> <- m3New.annotations, fun(e), 
						a == |java+interface:///java/lang/Deprecated|,
						|java+interface:///java/lang/Deprecated| notin m3Old.annotations[e]};
	deprecate = filterM3(m3New, elemsDeprecated);
	
	return applyMatchers(additions, deprecate, fun, options, DEP_MATCHERS);
}

private M3 filterM3(M3 m, set[loc] elems) {
	m3Filtered = m3(m.id);

	// Core M3 relations
	m3Filtered.declarations 	= filterElements(m.declarations, elems);
	m3Filtered.types 			= filterElements(m.types, elems);
	m3Filtered.uses 			= filterElements(m.uses, elems);
	m3Filtered.containment 		= filterElements(m.containment, elems);
	m3Filtered.names 			= filterElements(m.names, elems);
	m3Filtered.documentation 	= filterElements(m.documentation, elems);
	m3Filtered.modifiers 		= filterElements(m.modifiers, elems);

	// Java M3 relations
	m3Filtered.extends 			= filterElements(m.extends, elems);
	m3Filtered.implements 		= filterElements(m.implements, elems);
	m3Filtered.methodInvocation = filterElements(m.methodInvocation, elems);
	m3Filtered.fieldAccess 		= filterElements(m.fieldAccess, elems);
	m3Filtered.typeDependency 	= filterElements(m.typeDependency, elems);
	m3Filtered.methodOverrides 	= filterElements(m.methodOverrides, elems);
	m3Filtered.annotations 		= filterElements(m.annotations, elems);
	
	return m3Filtered;
}
	
private rel[&T, &R] filterElements(rel[&T, &R] relToFilter, set[&S] elems) {
	result = {};
	if (relToFilter != {} && elems != {}) {
		elemRel = getOneFrom(relToFilter);
		elemSet = getOneFrom(elems);
		
		if (<first, second> := elemRel) {
			result += (typeOf(first) == typeOf(elemSet)) ? domainR(relToFilter, elems) : {};
			result += (typeOf(second) == typeOf(elemSet)) ? rangeR(relToFilter, elems) : {};
		}
	}
	return result;
}

 
/*
 * Identifying removed elements
 * TODO: check that removed elements are not listed in renamed or moved sets
 */
private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, \class(_)) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	m3Diff = getRemovals(m3Old, m3New);	
	return {<elem, <parent, elem>> | <parent, elem> <- m3Diff.containment, isPackage(parent), isType(elem)};
}

private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, \method(_)) 
	= removed(m3Old, m3New, isMethod);
	
private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, \field(_)) 
	= removed(m3Old, m3New, isField);

private rel[loc, Mapping[loc, loc]] removed(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Diff = getRemovals(m3Old, m3New);	
	return {<elem, <parent, elem>> | <parent, elem> <- m3Diff.containment, fun(elem), isType(parent)};
}


/*
 * Identifying renamed elements
 */ 
private rel[loc, Mapping[loc, loc]] renamed(M3 m3Old, M3 m3New, BreakingChanges bc) {
	switch(bc) {
		case \class(_) : {
			m3Old.containment = m3Old.containment+;
			m3New.containment = m3New.containment+;
			return renamed(m3Old, m3New, isType, bc.options);
		}
		case \method(_) : return renamed(m3Old, m3New, isMethod, bc.options);
		case \field(_) : return renamed(m3Old, m3New, isField, bc.options);
		default : return {};
	}
}
	
private rel[loc, Mapping[loc, loc]] renamed(M3 m3Old, M3 m3New, bool (loc) fun, map[str,str] options) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);
	return applyMatchers(additions, removals, fun, options, MATCHERS);
}

rel[loc, Mapping[loc, loc]] applyMatchers(M3 additions, M3 removals, bool (loc) fun, map[str,str] options, str option) {
	matchers = (option in options) ? split(",", options[option]) : [];
	rel[loc, tuple[loc, loc]] result = {};
	
	// Default matcher: Jaccard
	if (matchers == []) {
		Matcher jaccardMatcher = matcher(jaccardMatch); 
		matches = jaccardMatcher.match(additions, removals, fun);
		result = { <from, <from, to>> | <from, to, conf> <- matches };
	}
	else {
		for(m <- matchers) { 
			Matcher currentMatcher = matcher(jaccardMatch); 
				
			switch(trim(m)) {
				case MATCH_LEVENSHTEIN : currentMatcher = matcher(levenshteinMatch);
				case MATCH_JACCARD : currentMatcher = matcher(jaccardMatch); 
				default : currentMatcher = matcher(jaccardMatch);
			}
				
			matches = currentMatcher.match(additions, removals, fun);
			// Removing tuples related to elements that have been checked by other matchers 
			matches = domainX(matches, domain(result));
				
			for(from <- domain(matches)) {
				bestConf = -1.0;
				bestTo = from;
					
				for(<to, conf> <- matches[from]) {
					if(conf > bestConf) {
						bestConf = conf;
						bestTo = to;
					}
				} 
					
				// Select the best match for each location
				result += <from, <from, bestTo>>;
				// Let's not iterate over the same elements
				matches = domainX(matches, {from});
			}
		}
	}
	
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
	
	methsNew = {<meth, typ> | <meth, typ> <- additions.types, isMethod(meth) || isConstructor(meth)};
	methsOld = {<meth, typ> | <meth, typ> <- removals.types, isMethod(meth) || isConstructor(meth)};
	
	result = {};
	for (<methNew, typeNew> <- methsNew) {
		for (<methOld, typeOld> <- methsOld, sameMethodQualName(methNew, methOld)) {
			elemsNew = fun(typeNew);
			elemsOld = fun(typeOld);
			
			if (elemsOld != elemsNew) {
				result += <methOld, <elemsOld, elemsNew>>;
			}
		}
	}
	return result;
}

// TODO: consider moving this function to Rascal module lang::java::m3::Core
private bool isType(loc entity) = isClass(entity) || isInterface(entity);

private bool sameMethodQualName(loc m1, loc m2) {
	m1Name = methodQualName(m1);
	m2Name = methodQualName(m2);
	return m1Name == m2Name;
} 

private str methodQualName(loc m) = (/<mPath: [a-zA-Z0-9.$\/]+>(<mParams: [a-zA-Z0-9.$\/]*>)/ := m.path) ? mPath : "";
private str methodName(loc m) = substring(methodQualName(m), (findLast(methodQualName(m), "/") + 1));
private list[TypeSymbol] methodParams(TypeSymbol typ) = (\method(_,_,_,params) := typ) ? params : [];
private TypeSymbol methodReturnType(TypeSymbol typ) = (\method(_,_,ret,_) := typ) ? ret : lang::java::m3::TypeSymbol::\void();


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