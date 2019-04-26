module org::maracas::bc::BreakingChangesBuilder

import IO;
import Boolean;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::m3::TypeSymbol;
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::M3;
import org::maracas::config::Options;
import org::maracas::diff::CodeSimilarityMatcher;
import org::maracas::io::properties::IO;
import org::maracas::diff::Matcher;
import Relation;
import Set;
import String;
import Type;


// extends lang::java::m3::AST::Modifier
// Could be moved to M3 creation itself
// but this is the quickest way :)
data Modifier =
	\defaultAccess();

@memo
M3 getRemovals(M3 m3Old, M3 m3New) {
	return diffJavaM3(m3Old.id, [fillDefaultVisibility(m3Old), fillDefaultVisibility(m3New)]);
}

@memo
M3 getAdditions(M3 m3Old, M3 m3New) {
	return diffJavaM3(m3Old.id, [fillDefaultVisibility(m3New), fillDefaultVisibility(m3Old)]);
}

M3 fillDefaultVisibility(M3 m3) {
	accMods = { \defaultAccess(), \public(), \private(), \protected() };

	m3.modifiers = m3.modifiers +
		{ <elem, \defaultAccess()> | elem <- domain(m3.declarations),
		                             (m3.modifiers[elem] & accMods) == {} };

	return m3;
}

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
	bc.deprecated = deprecated(m3Old, m3New, bc);
	bc.renamed = renamed(removals, additions, bc);
	bc.moved = moved(removals, additions, bc);
	//bc.removed = removed(m3Old, additions, bc);
	bc.changedExtends = changedExtends(removals, additions);
	bc.changedImplements = changedImplements(removals, additions);
	//return postproc(bc);
	return bc;
}

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
	bc.renamed = renamed(removals, additions, bc);
	bc.moved = moved(removals, additions, bc);
	//bc.removed = removed(m3Old, additions, bc);
	
	//return postproc(bc);
	return bc;
}

BreakingChanges createFieldBC(M3 m3Old, M3 m3New, loc optionsFile = |project://maracas/config/config.properties|) {
	additions = getAdditions(m3Old, m3New);
	removals = getRemovals(m3Old, m3New);
	
	id = createBCId(m3Old, m3New);
	bc = field(id);
	bc.options = readProperties(optionsFile);
	bc.changedAccessModifier = changedAccessModifier(removals, additions, bc);
	bc.changedFinalModifier = changedFinalModifier(removals, additions, bc);
	bc.changedStaticModifier = changedStaticModifier(removals, additions, bc);
	bc.changedType = changedType(removals, additions);
	bc.deprecated = deprecated(m3Old, m3New, bc);
	bc.renamed = renamed(removals, additions, bc);
	//bc.removed = removed(m3Old, additions, bc);
	
	//return postproc(bc);
	return bc;
}

private tuple[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;


/*
 * Identifying changes in access modifiers
 */
// TODO: manage package modifier.
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, \class(_)) 
	= changedAccessModifier(removals, additions, isType);
	
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, \method(_)) 
	= changedAccessModifier(removals, additions, isMethod);
	
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, \field(_)) 
	= changedAccessModifier(removals, additions, isField);

private rel[loc, Mapping[Modifier]] changedAccessModifier(M3 removals, M3 additions, bool (loc) fun) {
	accMods = { \defaultAccess(), \public(), \private(), \protected() };
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
			removals = filterXM3(removals, bc.changedParamList.elem);
			return renamed(removals, additions, isMethod, bc.options);
		}
		case \field(_) : return renamed(removals, additions, isField, bc.options);
		default : return {};
	}
}
	
private rel[loc, Mapping[loc]] renamed(M3 removals, M3 additions, bool (loc) fun, map[str,str] options) {
	result = {};
	
	for (<cont, elem> <- removals.containment, removals.declarations[elem] != {}, fun(elem)) {
		// In type cases we need the owner package instead of its compilation unit.
		if (isCompilationUnit(cont)) {
			cont = getOneFrom(invert(removals.containment)[cont]);
		}
		
		elemsSameCont = {};
		for (a <- additions.containment[cont], additions.declarations[a] != {}) {
			if (isCompilationUnit(a)) {
				a = getOneFrom(additions.containment[a]);
			}
			if (fun(a)) {
				elemsSameCont += a;
			}
		}
		
		if (elemsSameCont != {}) {
			removalsTemp = filterM3(removals, {elem});
			additionsTemp = filterM3(additions, elemsSameCont);
			result += applyMatchers(additionsTemp, removalsTemp, fun, options, MATCHERS);
		}
	}
	return result;
}


private rel[loc, Mapping[loc]] moved(M3 removals, M3 additions, BreakingChanges bc) {
	// Filter additions and removals M3 models for the sake of performance
	removals = filterXM3(removals, bc.renamed.mapping<0>);
	removals = filterXM3(removals, bc.changedStaticModifier.elem);
	additions = filterXM3(additions, bc.renamed.mapping<1>);
	
	switch(bc) {
		case \class(_) : return moved(removals, additions, isType, bc.options);
		case \method(_) : {
			removals = filterXM3(removals, bc.changedParamList.elem);
			return moved(removals, additions, isMethod, bc.options);
		}
		case \field(_) : return moved(removals, additions, isField, bc.options);
		default : return {};
	}
}

private rel[loc, Mapping[loc]] moved(M3 removals, M3 additions, bool (loc) fun, map[str,str] options) {
	result = {};
	for (<cont, elem> <- removals.containment, removals.declarations[elem] != {}, fun(elem)) {
		removalsTemp = filterM3(removals, {elem});
		result += applyMatchers(additions, removalsTemp, fun, options, MATCHERS);
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

/*
 * Identifying changes in field return types
 */
rel[loc, Mapping[TypeSymbol]] changedType(M3 removals, M3 additions) {
	fieldsAdded =   { <f, typ> | <f, typ> <- additions.types, isField(f) };
	fieldsRemoved = { <f, typ> | <f, typ> <- removals.types,  isField(f) };

	result = {};
	for (<fieldAdded, typeAdded> <- fieldsAdded) {
		for (<fieldRemoved, typeRemoved> <- fieldsRemoved,
				fieldAdded == fieldRemoved,
				typeAdded  != typeRemoved) {
			result += <fieldRemoved, <typeRemoved, typeAdded, 1.0, MATCH_SIGNATURE>>;
		}
	}

	return result;
}

/*
 * Identifying changes in class/interface extends/implements relations
 */
rel[loc, Mapping[loc]] changedExtends(M3 removals, M3 additions) {
	result = {};
	
	for (<cls, oldSup> <- removals.extends) {
		newSup = additions.extends[cls];
		newSupLoc = size(newSup) == 1 ? getOneFrom(newSup) : |unknown:///|;
		result += <cls, <oldSup, newSupLoc, 1.0, MATCH_SIGNATURE>>;
	}

	for (<cls, newSup> <- additions.extends) {
		oldSup = removals.extends[cls];
		oldSupLoc = size(oldSup) == 1 ? getOneFrom(oldSup) : |unknown:///|;
		result += <cls, <oldSupLoc, newSup, 1.0, MATCH_SIGNATURE>>;
	}
	
	return result;
}

rel[loc, Mapping[set[loc]]] changedImplements(M3 removals, M3 additions) {
	return { <typ,
				<removals.implements[typ],
				additions.implements[typ],
				1.0,
				MATCH_SIGNATURE>
			 > | typ <- domain(removals.implements) + domain(additions.implements)
			};
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
