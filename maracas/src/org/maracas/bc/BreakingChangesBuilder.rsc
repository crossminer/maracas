module org::maracas::bc::BreakingChangesBuilder

import IO;
import Boolean;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::m3::TypeSymbol;
import org::maracas::bc::BreakingChanges;
import org::maracas::config::Options;
import org::maracas::diff::CodeSimilarityMatcher;
import org::maracas::io::properties::IO;
import org::maracas::diff::Matcher;
import Relation;
import Set;
import String;
import Type;


@memo M3 getRemovals(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3Old, m3New]);
@memo M3 getAdditions(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3New, m3Old]);

@memo
BreakingChanges createClassBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	removals = getRemovals(m3Old, m3New);
	additions = getAdditions(m3Old, m3New);
	
	id = createBCId(m3Old, m3New);
	bc = class(id);
	bc.options = readProperties(optionsFile);
	bc.changedAccessModifier = changedAccessModifier(removals, additions, bc);
	bc.changedFinalModifier = changedFinalModifier(removals, additions, bc);
	bc.changedStaticModifier = changedStaticModifier(removals, additions, bc);
	bc.changedAbstractModifier = changedAbstractModifier(removals, additions, bc);
	//TODO: moved
	bc.deprecated = deprecated(m3Old, m3New, bc);
	//bc.removed = removed(m3Old, additions, bc);
	bc.renamed = renamed(removals, additions, bc);
	
	//return postproc(bc);
	return bc;
}

@memo
BreakingChanges createMethodBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	removals = getRemovals(m3Old, m3New);
	additions = getAdditions(m3Old, m3New);
	
	id = createBCId(m3Old, m3New);
	bc = method(id);
	bc.options = readProperties(optionsFile);
	bc.changedAccessModifier = changedAccessModifier(removals, additions, bc);
	bc.changedFinalModifier = changedFinalModifier(removals, additions, bc);
	bc.changedStaticModifier = changedStaticModifier(removals, additions, bc);
	bc.changedAbstractModifier = changedAbstractModifier(removals, additions, bc);
	bc.changedParamList = changedParamList(removals, additions);
	bc.changedReturnType = changedReturnType(removals, additions);
	bc.deprecated = deprecated(m3Old, m3New, bc);
	// TODO: After changedParamList computation we filter its domain from additions
	// and removals models. 
	bc.renamed = renamed(removals, additions, bc);
	
	//TODO: moved
	//bc.removed = removed(m3Old, additions, bc);
	
	//return postproc(bc);
	return bc;
}

@memo
BreakingChanges createFieldBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);
	
	id = createBCId(m3Old, m3New);
	bc = field(id);
	bc.options = readProperties(optionsFile);
	bc.changedAccessModifier = changedAccessModifier(removals, additions, bc);
	bc.changedFinalModifier = changedFinalModifier(removals, additions, bc);
	bc.changedStaticModifier = changedStaticModifier(removals, additions, bc);
	//TODO: moved
	bc.deprecated = deprecated(m3Old, m3New, bc);
	//bc.removed = removed(m3Old, additions, bc);
	bc.renamed = renamed(removals, additions, bc);
	
	//return postproc(bc);
	return bc;
}

private tuple[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;


/*
 * Identifying changes in access modifiers
 */
// TODO: manage package modifier.
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, \class(_)) 
	= changedAccessModifier(removals, additions, isClass);
	
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, \method(_)) 
	= changedAccessModifier(removals, additions, isMethod);
	
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, \field(_)) 
	= changedAccessModifier(removals, additions, isField);

private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, bool (loc) fun) {
	accMods = { \public(), \private(), \protected() };
	result = {};
	// The confidence of the mapping is 1 if the signature is the same
	for (<elem, modifAdded> <- additions.modifiers, fun(elem), modifAdded in accMods) {
		for (modifRemoved <- removals.modifiers[elem], modifRemoved in accMods) {
			result += { <elem, <modifRemoved, modifAdded, 1.0, MATCH_SIGNATURE>> };
		}
	}
	return result;
}

/*
 * Identifying changes in final modifiers
 */
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3 removals, M3 additions, \class(_)) 
	= changedFinalModifier(removals, additions, isClass);
	
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3 removals, M3 additions, \method(_)) 
	= changedFinalModifier(removals, additions, isMethod);
	
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3 removals, M3 additions, \field(_)) 
	= changedFinalModifier(removals, additions, isField);
	
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3 removals, M3 additions, bool (loc) fun) 
	= changedModifier(removals, additions, fun, \final());


/*
 * Identifying changes in static modifiers
 */
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3 removals, M3 additions, \class(_)) 
	= changedStaticModifier(removals, additions, isClass);
	
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3 removals, M3 additions, \method(_)) 
	= changedStaticModifier(removals, additions, isMethod);
	
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3 removals, M3 additions, \field(_)) 
	= changedStaticModifier(removals, additions, isField);
	
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3 removals, M3 additions, bool (loc) fun) 
	= changedModifier(removals, additions, fun, \static());


/*
 * Identifying changes in abstract modifiers
 */
private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3 removals, M3 additions, \class(_)) 
	= changedAbstractModifier(removals, additions, isClass);

private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3 removals, M3 additions, \method(_)) 
	= changedAbstractModifier(removals, additions, isMethod);

private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3 removals, M3 additions, bool (loc) fun) 
	= changedModifier(removals, additions, fun, \abstract());

// The confidence of the mapping is 1 if the signature is the same
private rel[loc, Mapping[Modifier]] changedModifier(M3 removals, M3 additions, bool (loc) fun, Modifier modifier) 
	= { <elem, <\default(), modif, 1.0, MATCH_SIGNATURE>> 
	| <elem, modif> <- additions.modifiers, modif := modifier, fun(elem) }
	+ { <elem, <modif, \default(), 1.0, MATCH_SIGNATURE>> 
	| <elem, modif> <- removals.modifiers, modif := modifier, fun(elem) };


/*
 * Identifying deprecated elements. It only considers deprecated elements
 * introduced in m3New.
 * TODO: annotations rel in M3 from source code is not working properly.  
 */
private rel[loc, Mapping[loc]] deprecated(M3 m3Old, M3 m3New, BreakingChanges bc) {
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

private rel[loc, Mapping[loc]] deprecated(M3 m3Old, M3 m3New, bool (loc) fun, map[str,str] options) {
	load = DEP_MATCHES_LOAD in options && fromString(options[DEP_MATCHES_LOAD]);
	
	// TODO: check that we only load matches from a certain kind (i.e. class, method, field)	
	if (load) {
		url = |file://| + options[DEP_MATCHES_LOC];
		matches = loadMatches(url);
		return { <from, <from, to, conf, meth>>| <from, to, conf, meth> <- matches };
	}
	
	// For now, only mark @Deprecated elements
	return { <e, <e, e, 1.0, MATCH_SIGNATURE>> | <e, a> <- m3New.annotations, fun(e),
						a == |java+interface:///java/lang/Deprecated|,
						m3Old.declarations[e] != {},
						|java+interface:///java/lang/Deprecated| notin m3Old.annotations[e] };

	//additions = getAdditions(m3Old, m3New);
	//deprecate = filterM3(m3New, elemsDeprecated);
	//return applyMatchers(additions, deprecate, fun, options, DEP_MATCHERS);
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

 
/*
 * Identifying removed elements
 * TODO: check that removed elements are not listed in renamed or moved sets
 */
private rel[loc, Mapping[loc]] removed(M3 removals, M3 additions, \class(_)) {
	//TODO: refactor this
	//m3Old.containment = m3Old.containment+;
	//m3New.containment = m3New.containment+;
	//m3Diff = getRemovals(m3Old, m3New);	
	
	// FIXME: match signature?
	return { <elem, <parent, elem, 1.0, MATCH_SIGNATURE>> 
		| <parent, elem> <- removals.containment, isPackage(parent), isType(elem) };
}

private rel[loc, Mapping[loc]] removed(M3 removals, M3 additions, \method(_)) 
	= removed(removals, additions, isMethod);
	
private rel[loc, Mapping[loc]] removed(M3 removals, M3 additions, \field(_)) 
	= removed(removals, additions, isField);

// FIXME: match signature?
private rel[loc, Mapping[loc]] removed(M3 removals, M3 additions, bool (loc) fun)
	= { <elem, <parent, elem, 1.0, MATCH_SIGNATURE>> 
	| <parent, elem> <- removals.containment, fun(elem), isType(parent) };


/*
 * Identifying renamed elements
 */ 
private rel[loc, Mapping[loc]] renamed(M3 removals, M3 additions, BreakingChanges bc) {
	switch(bc) {
		case \class(_) : return renamed(removals, additions, isType, bc.options);
		case \method(_) : {
		// TODO: remove this code once changedParamList is correctly computed: 
		// additions and removals must be filtered first 
			result = renamed(removals, additions, isMethod, bc.options);
			for (<elem, <from, to, conf, meth>> <- result) {
				if (methodQualName(from) == methodQualName(to)) {
					result = domainX(result, {elem});
				}
			}
			return result;
		}
		case \field(_) : return renamed(removals, additions, isField, bc.options);
		default : return {};
	}
}
	
private rel[loc, Mapping[loc]] renamed(M3 removals, M3 additions, bool (loc) fun, map[str,str] options) {
	result = {};
	for (<cont, elem> <- removals.containment, removals.declarations[elem] != {}, fun(elem)) {
		elemsSameCont = { a | a <- additions.containment[cont], additions.declarations[a] != {}, fun(a) };
		removalsTemp = filterM3(removals, {elem});
		additionsTemp = filterM3(additions, elemsSameCont);
		result += applyMatchers(additionsTemp, removalsTemp, fun, options, MATCHERS);
	}
	return result;
}

rel[loc, Mapping[loc]] applyMatchers(M3 additions, M3 removals, bool (loc) fun, map[str,str] options, str option) {
	matchers = (option in options) ? split(",", options[option]) : []; 
	result = {};
	
	// Default matcher: Jaccard
	if (matchers == []) {
		Matcher jaccardMatcher = matcher(jaccardMatch); 
		matches = jaccardMatcher.match(additions, removals, fun);
		result = { <from, <from, to, conf, meth>> | <from, to, conf, meth> <- matches };
	}
	else {
		for (m <- matchers) { 
			Matcher currentMatcher = matcher(jaccardMatch); 
				
			switch (trim(m)) {
				case MATCH_LEVENSHTEIN : currentMatcher = matcher(levenshteinMatch);
				case MATCH_JACCARD : currentMatcher = matcher(jaccardMatch); 
				default : currentMatcher = matcher(jaccardMatch);
			}
				
			matches = currentMatcher.match(additions, removals, fun);
			// Removing tuples related to elements that have been checked by other matchers 
			matches = domainX(matches, domain(result));
				
			for (from <- domain(matches)) {
				bestConf = -1.0;
				bestTo = from;
				bestMeth = "";
					
				for (<to, conf, meth> <- matches[from]) {
					if (conf > bestConf) {
						bestConf = conf;
						bestTo = to;
						bestMeth = meth;
					}
				} 
					
				// Select the best match for each location
				result += <from, <from, bestTo, bestConf, bestMeth>>;
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
rel[loc, Mapping[list[TypeSymbol]]] changedParamList(M3 removals, M3 additions) 
	= changedMethodSignature(removals, additions, methodParams);


/*
 * Identifying changes in method return types
 */
rel[loc, Mapping[TypeSymbol]] changedReturnType(M3 removals, M3 additions)
	= changedMethodSignature(removals, additions, methodReturnType);
	

private rel[loc, Mapping[&T]] changedMethodSignature(M3 removals, M3 additions, &T (&U) fun) {
	// FIXME: M3 types relation is empty when generating it from a jar. Change it in the rascal side
	methsAdded = { <meth, typ> | <meth, typ> <- additions.types, isMethod(meth) || isConstructor(meth) };
	methsRemoved = { <meth, typ> | <meth, typ> <- removals.types, isMethod(meth) || isConstructor(meth) };
		
	result = {};
	for (<methAdded, typeAdded> <- methsAdded) {
		for (<methRemoved, typeRemoved> <- methsRemoved, sameMethodQualName(methAdded, methRemoved)) {
			elemsAdded = fun(typeAdded);
			elemsRemoved = fun(typeRemoved);
			
			if (elemsRemoved != elemsAdded) {
				result += <methRemoved, <elemsRemoved, elemsAdded, 1.0, MATCH_SIGNATURE>>;
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

	bc.changedAccessModifier = { <e, m> | <e, m> <- bc.changedAccessModifier, include(e) };
	bc.changedFinalModifier  = { <e, m> | <e, m> <- bc.changedFinalModifier,  include(e) };
	bc.changedStaticModifier = { <e, m> | <e, m> <- bc.changedStaticModifier, include(e) };
	bc.changedAbstractModifier = { <e, m> | <e, m> <- bc.changedAbstractModifier, include(e) };
	bc.moved   = { <e, m> | <e, m> <- bc.moved,   include(e), include(m[0]), include(m[1]) };
	bc.removed = { <e, m> | <e, m> <- bc.removed, include(e), include(m[0]), include(m[1]) };
	bc.renamed = { <e, m> | <e, m> <- bc.renamed, include(e), include(m[0]), include(m[1]) };
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