module org::maracas::delta::DeltaBuilder

import IO;
import Boolean;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::m3::TypeSymbol;
import org::maracas::config::Options;
import org::maracas::delta::Delta;
import org::maracas::match::CodeSimilarityMatcher;
import org::maracas::match::Matcher;
import org::maracas::io::properties::IO;
import org::maracas::m3::Core;
import org::maracas::m3::M3Diff;
import Relation;
import Set;
import String;
import Type;


Delta createClassDelta(M3 m3Old, M3 m3New, loc optionsFile = |file:///maracas/config.properties|) {
	M3Diff diff = createM3Diff(m3Old, m3New);
	
	id = createDeltaId(m3Old, m3New);
	delta = class(id);
	delta.options = readProperties(optionsFile);
	delta.changedAccessModifier = changedAccessModifier(diff, delta);
	delta.changedFinalModifier = changedFinalModifier(diff, delta);
	delta.changedStaticModifier = changedStaticModifier(diff, delta);
	delta.changedAbstractModifier = changedAbstractModifier(diff, delta);
	delta.deprecated = deprecated(diff, delta);
	delta.renamed = renamed(diff, delta);
	delta.moved = moved(diff, delta);
	delta.removed = removed(diff, delta);
	delta.changedExtends = changedExtends(diff);
	delta.changedImplements = changedImplements(diff);
	//return postproc(delta);
	return delta;
}

Delta createMethodDelta(M3 m3Old, M3 m3New, loc optionsFile = |file:///maracas/config.properties|) {
	M3Diff diff = createM3Diff(m3Old, m3New);
	
	id = createDeltaId(m3Old, m3New);
	delta = method(id);
	delta.options = readProperties(optionsFile);
	delta.changedAccessModifier = changedAccessModifier(diff, delta);
	delta.changedFinalModifier = changedFinalModifier(diff, delta);
	delta.changedStaticModifier = changedStaticModifier(diff, delta);
	delta.changedAbstractModifier = changedAbstractModifier(diff, delta);
	delta.changedParamList = changedParamList(diff);
	delta.changedReturnType = changedReturnType(diff);
	delta.deprecated = deprecated(diff, delta);
	delta.renamed = renamed(diff, delta);
	delta.moved = moved(diff, delta);
	delta.removed = removed(diff, delta);
	
	//return postproc(delta);
	return delta;
}

Delta createFieldDelta(M3 m3Old, M3 m3New, loc optionsFile = |file:///maracas/config.properties|) {
	M3Diff diff = createM3Diff(m3Old, m3New);
	
	id = createDeltaId(m3Old, m3New);
	delta = field(id);
	delta.options = readProperties(optionsFile);
	delta.changedAccessModifier = changedAccessModifier(diff, delta);
	delta.changedFinalModifier = changedFinalModifier(diff, delta);
	delta.changedStaticModifier = changedStaticModifier(diff, delta);
	delta.changedType = changedType(diff);
	delta.deprecated = deprecated(diff, delta);
	delta.renamed = renamed(diff, delta);
	delta.removed = removed(diff, delta);
	
	//return postproc(delta);
	return delta;
}

private tuple[loc,loc] createDeltaId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;


/*
 * Identifying changes in access modifiers
 */
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3Diff diff, \class(_)) 
	= changedAccessModifier(diff, isType);
	
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3Diff diff, \method(_)) 
	= changedAccessModifier(diff, isMethod);
	
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3Diff diff, \field(_)) 
	= changedAccessModifier(diff, isField);

private rel[loc, Mapping[Modifier]] changedAccessModifier(M3Diff diff, bool (loc) fun) {
	accMods = { \defaultAccess(), \public(), \private(), \protected() };
	result = {};

	// The confidence of the mapping is 1 if the signature is the same
	for (<elem, modifAdded> <- diff.additions.modifiers, fun(elem), modifAdded in accMods) {
		for (modifRemoved <- diff.removals.modifiers[elem], modifRemoved in accMods) {
			result += { <elem, <modifRemoved, modifAdded, 1.0, MATCH_SIGNATURE>> };
		}
	}

	return result;
}

/*
 * Identifying changes in final modifiers
 */
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3Diff diff, \class(_)) 
	= changedFinalModifier(diff, isClass);
	
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3Diff diff, \method(_)) 
	= changedFinalModifier(diff, isMethod);
	
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3Diff diff, \field(_)) 
	= changedFinalModifier(diff, isField);
	
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3Diff diff, bool (loc) fun) 
	= changedModifier(diff, fun, \final());


/*
 * Identifying changes in static modifiers
 */
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3Diff diff, \class(_)) 
	= changedStaticModifier(diff, isClass);
	
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3Diff diff, \method(_)) 
	= changedStaticModifier(diff, isMethod);
	
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3Diff diff, \field(_)) 
	= changedStaticModifier(diff, isField);
	
private rel[loc, Mapping[Modifier]] changedStaticModifier(M3Diff diff, bool (loc) fun) 
	= changedModifier(diff, fun, \static());


/*
 * Identifying changes in abstract modifiers
 */
private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3Diff diff, \class(_)) 
	= changedAbstractModifier(diff, isClass);

private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3Diff diff, \method(_)) 
	= changedAbstractModifier(diff, isMethod);

private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3Diff diff, bool (loc) fun) 
	= changedModifier(diff, fun, \abstract());

// The confidence of the mapping is 1 if the signature is the same
private rel[loc, Mapping[Modifier]] changedModifier(M3Diff diff, bool (loc) fun, Modifier modifier) 
	= { <elem, <\default(), modif, 1.0, MATCH_SIGNATURE>> 
	| <elem, modif> <- diff.additions.modifiers, modif := modifier, fun(elem) }
	+ { <elem, <modif, \default(), 1.0, MATCH_SIGNATURE>> 
	| <elem, modif> <- diff.removals.modifiers, modif := modifier, fun(elem) };


/*
 * Identifying deprecated elements. It only considers deprecated elements
 * introduced in the new version.
 * TODO: annotations rel in M3 from source code is not working properly.  
 */
private rel[loc, Mapping[loc]] deprecated(M3Diff diff, Delta delta) {
	switch (delta) {
		case \class(_) : {
			return deprecated(diff, isType, delta.options);
		}
		case \method(_) : return deprecated(diff, isMethod, delta.options);
		case \field(_) : return deprecated(diff, isField, delta.options);
		default : return {};
	}
}

private rel[loc, Mapping[loc]] deprecated(M3Diff diff, bool (loc) fun, map[str,str] options) {
	load = DEP_MATCHES_LOAD in options && fromString(options[DEP_MATCHES_LOAD]);
	
	// TODO: check that we only load matches from a certain kind (i.e. class, method, field)	
	if (load) {
		url = |file://| + options[DEP_MATCHES_LOC];
		matches = loadMatches(url);
		return { <from, <from, to, conf, meth>>| <from, to, conf, meth> <- matches };
	}
	
	// For now, only mark @Deprecated elements
	return { <e, <e, e, 1.0, MATCH_SIGNATURE>> | <e, a> <- diff.additions.annotations, fun(e),
						a == |java+interface:///java/lang/Deprecated|};

	//additions = getAdditions(m3Old, m3New);
	//deprecate = filterM3(m3New, elemsDeprecated);
	//return applyMatchers(additions, deprecate, fun, options, DEP_MATCHERS);
}


/*
 * Identifying renamed elements
 */ 
private rel[loc, Mapping[loc]] renamed(M3Diff diff, Delta delta) {
	switch(delta) {
		case \class(_) : return renamed(diff, isType, delta.options);
		case \method(_) : {
			elemsRemovals = (!isEmpty(delta.changedParamList)) ? delta.changedParamList.elem : {};
			diff.removals = filterXM3(diff.removals, elemsRemovals);
			return renamed(diff, isMethod, delta.options);
		}
		case \field(_) : return renamed(diff, isField, delta.options);
		default : return {};
	}
}
	
private rel[loc, Mapping[loc]] renamed(M3Diff diff, bool (loc) fun, map[str,str] options) {
	removals = diff.removals;
	additions = diff.additions;
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
			diffTemp = diff;
			diffTemp.removals = filterM3(removals, {elem});
			diffTemp.additions = filterM3(additions, elemsSameCont);
			result += applyMatchers(diffTemp, fun, options, MATCHERS);
		}
	}
	return result;
}


private rel[loc, Mapping[loc]] moved(M3Diff diff, Delta delta) {
	// Filter additions and removals M3 models for the sake of performance
	elemsRemovals = (!isEmpty(delta.renamed)) ? delta.renamed.mapping<0> : {};
	elemsAdditions = (!isEmpty(delta.renamed)) ? delta.renamed.mapping<1> : {};
		
	diff.removals = filterXM3(diff.removals, elemsRemovals);
	diff.additions = filterXM3(diff.additions, elemsAdditions);
	
	switch(delta) {
		case \class(_) : return moved(diff, isType, delta.options);
		case \method(_) : {
			elemsRemovals = (!isEmpty(delta.changedParamList)) ? delta.changedParamList.elem : {};
			diff.removals = filterXM3(diff.removals, elemsRemovals);
			return moved(diff, isMethod, delta.options);
		}
		case \field(_) : return moved(diff, isField, delta.options);
		default : return {};
	}
}

private rel[loc, Mapping[loc]] moved(M3Diff diff, bool (loc) fun, map[str,str] options) {
	removals = diff.removals;
	additions = diff.additions;
	result = {};
	
	for (<cont, elem> <- removals.containment, removals.declarations[elem] != {}, fun(elem)) {
		diffTemp = diff;
		diffTemp.removals = filterM3(removals, {elem});
		result += applyMatchers(diffTemp, fun, options, MATCHERS);
	}
	
	return result;
}


/*
 * Identifying removed elements
 */
private rel[loc, Mapping[loc]] removed(M3Diff diff, Delta delta) {
	elemsRemovals = ((!isEmpty(delta.renamed)) ? delta.renamed.mapping<0> : {}) 
		+ ((!isEmpty(delta.moved)) ? delta.moved.mapping<0> : {});
	elemsAdditions = ((!isEmpty(delta.renamed)) ? delta.renamed.mapping<1> : {}) 
		+ ((!isEmpty(delta.moved)) ? delta.moved.mapping<1> : {});
		
	diff.removals = filterXM3(diff.removals, elemsRemovals);
	diff.additions = filterXM3(diff.additions, elemsAdditions);
	
	switch(delta) {
		case \class(_) : return removed(diff, isType);
		case \method(_) : {
			elemsRemovals = (!isEmpty(delta.changedParamList)) ? delta.changedParamList.elem : {};
			diff.removals = filterXM3(diff.removals, elemsRemovals);
			return removed(diff, isMethod);
		}
		case \field(_) : return removed(diff, isField);
		default : return {};
	}
}

// FIXME: match signature?
private rel[loc, Mapping[loc]] removed(M3Diff diff, bool (loc) fun)
	= { <elem, <elem, |unknown:///|, 1.0, MATCH_SIGNATURE>> 
	| <parent, elem> <- diff.removals.containment, fun(elem) };
	
	
rel[loc, Mapping[loc]] applyMatchers(M3Diff diff, bool (loc) fun, map[str,str] options, str option) {
	matchers = (option in options) ? split(",", options[option]) : []; 
	result = {};
	
	// Default matcher: Jaccard
	if (matchers == []) {
		Matcher jaccardMatcher = matcher(jaccardMatch); 
		matches = jaccardMatcher.match(diff, fun);
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
				
			matches = currentMatcher.match(diff, fun);
			
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
rel[loc, Mapping[list[TypeSymbol]]] changedParamList(M3Diff diff) 
	= changedMethodSignature(diff, methodParams);


/*
 * Identifying changes in method return types
 */
rel[loc, Mapping[TypeSymbol]] changedReturnType(M3Diff diff)
	= changedMethodSignature(diff, methodReturnType);
	

private rel[loc, Mapping[&T]] changedMethodSignature(M3Diff diff, &T (&U) fun) {
	methsAdded = { <meth, typ> | <meth, typ> <- diff.additions.types, isMethod(meth) || isConstructor(meth) };
	methsRemoved = { <meth, typ> | <meth, typ> <- diff.removals.types, isMethod(meth) || isConstructor(meth) };
		
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
rel[loc, Mapping[TypeSymbol]] changedType(M3Diff diff) {
	fieldsAdded =   { <f, typ> | <f, typ> <- diff.additions.types, isField(f) };
	fieldsRemoved = { <f, typ> | <f, typ> <- diff.removals.types,  isField(f) };

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
rel[loc, Mapping[loc]] changedExtends(M3Diff diff) {
	result = {};
	
	for (<cls, oldSup> <- diff.removals.extends) {
		newSup = diff.additions.extends[cls];
		newSupLoc = size(newSup) == 1 ? getOneFrom(newSup) : |unknown:///|;
		result += <cls, <oldSup, newSupLoc, 1.0, MATCH_SIGNATURE>>;
	}

	for (<cls, newSup> <- diff.additions.extends) {
		oldSup = diff.removals.extends[cls];
		oldSupLoc = size(oldSup) == 1 ? getOneFrom(oldSup) : |unknown:///|;
		result += <cls, <oldSupLoc, newSup, 1.0, MATCH_SIGNATURE>>;
	}
	
	return result;
}

rel[loc, Mapping[set[loc]]] changedImplements(M3Diff diff) {
	removals = diff.removals;
	additions = diff.additions;
	
	return { <typ,
				<removals.implements[typ],
				additions.implements[typ],
				1.0,
				MATCH_SIGNATURE>
			 > | typ <- domain(removals.implements) + domain(additions.implements)
			};
}

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

private Delta postproc(Delta delta) {
	delta = postprocRenamed(delta);

	delta.changedAccessModifier = { <e, m> | <e, m> <- delta.changedAccessModifier, include(e) };
	delta.changedFinalModifier  = { <e, m> | <e, m> <- delta.changedFinalModifier,  include(e) };
	delta.changedStaticModifier = { <e, m> | <e, m> <- delta.changedStaticModifier, include(e) };
	delta.changedAbstractModifier = { <e, m> | <e, m> <- delta.changedAbstractModifier, include(e) };
	delta.moved   = { <e, m> | <e, m> <- delta.moved,   include(e), include(m[0]), include(m[1]) };
	delta.removed = { <e, m> | <e, m> <- delta.removed, include(e), include(m[0]), include(m[1]) };
	delta.renamed = { <e, m> | <e, m> <- delta.renamed, include(e), include(m[0]), include(m[1]) };
	//delta.changedParamList  = {<e, m> | <e, m> <- delta.changedParamList,  include(e)};
	//delta.changedReturnType = {<e, m> | <e, m> <- delta.changedReturnType, include(e)};
	//delta.changedType       = {<e, m> | <e, m> <- delta.changedType,       include(e)};

	switch (delta) {
		case \method(_) : return postprocMethodBC(delta);
		default : return delta; 
	}
}

private bool include(loc l) {
	return /org\/sonar\/api\/internal\// !:= l.uri;
}
 
private Delta postprocMethodBC(Delta delta) { 
	delta = postprocChangedParamList(delta);
	return delta;
}

private Delta postprocRenamed(Delta delta) {
	delta.removed = domainX(delta.removed, (delta.removed.elem & delta.renamed.elem));
	return delta;
}

private Delta postprocChangedParamList(Delta delta) {
	delta.removed = domainX(delta.removed, (delta.removed.elem & delta.changedParamList.elem));
	return delta;
}
