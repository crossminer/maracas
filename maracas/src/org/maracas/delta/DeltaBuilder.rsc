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


Delta createDelta(M3 from, M3 to, loc optionsFile = |file:///maracas/config.properties|) {
	M3Diff diff = createM3Diff(from, to);
	
	Delta delta = delta(<from.id, to.id>);
	delta.options = readProperties(optionsFile);
	delta.changedAccessModifier = changedAccessModifier(diff); 
	delta.changedFinalModifier = changedFinalModifier(diff);
	delta.changedStaticModifier = changedStaticModifier(diff);
	delta.changedAbstractModifier = changedAbstractModifier(diff);
	delta.deprecated = deprecated(diff, delta);
	delta.renamed = renamed(diff, delta);
	delta.moved = moved(diff, delta);
	delta.removed = removed(diff, delta);
	delta.changedExtends = changedExtends(diff);
	delta.changedImplements = changedImplements(diff);
	delta.changedParamList = changedParamList(diff);
	delta.changedType = changedReturnType(diff) + changedType(diff);
	
	//return postproc(delta);
	return delta;
}
	
/*
 * Identifying changes in access modifiers
 */
private rel[loc, Mapping[Modifier]] changedAccessModifier(M3Diff diff) {
	result = {};
	// The confidence of the mapping is 1 if the signature is the same
	for (<e, addMod> <- diff.additions.modifiers, isTargetMember(e), isAccessModifier(addMod)) {
		for (remMod <- diff.removals.modifiers[e], isAccessModifier(remMod)) {
			result += buildMapping(e, remMod, addMod, 1.0, MATCH_SIGNATURE);
		}
	}

	return result;
}

private bool isAccessModifier(Modifier m) {
	accMods = { 
		\defaultAccess(), 
		\public(), 
		\private(), 
		\protected() 
	};
	return m in accMods;
}

/*
 * Identifying changes in final, static, and abstract modifiers
 */
private rel[loc, Mapping[Modifier]] changedFinalModifier(M3Diff diff) 
	= changedModifier(diff, \final());

private rel[loc, Mapping[Modifier]] changedStaticModifier(M3Diff diff) 
	= changedModifier(diff, \static());

private rel[loc, Mapping[Modifier]] changedAbstractModifier(M3Diff diff) 
	= changedModifier(diff, \abstract());

// The confidence of the mapping is 1 if the signature is the same
private rel[loc, Mapping[Modifier]] changedModifier(M3Diff diff, Modifier modifier) 
	= { buildMapping(elem, \default(), modif, 1.0, MATCH_SIGNATURE)
	| <elem, modif> <- diff.additions.modifiers, isTargetMemberExclInterface(elem), modif := modifier }
	+ { buildMapping(elem, modif, \default(), 1.0, MATCH_SIGNATURE)
	| <elem, modif> <- diff.removals.modifiers, isTargetMemberExclInterface(elem), modif := modifier };


private rel[loc, Mapping[loc]] deprecated(M3Diff diff, Delta delta) {
	load = DEP_MATCHES_LOAD in delta.options && fromString(delta.options[DEP_MATCHES_LOAD]);
	
	// TODO: check that we only load matches from a certain kind (i.e. class, method, field)	
	if (load) {
		url = |file://| + delta.options[DEP_MATCHES_LOC];
		matches = loadMatches(url);
		return { buildMapping(m.from, m) | m <- matches };
	}
	
	// For now, only mark @Deprecated elements
	return { buildMapping(e, e, e, 1.0, MATCH_SIGNATURE) 
			| 	<e, a> <- diff.additions.annotations, isTargetMember(e),
				a == |java+interface:///java/lang/Deprecated|};

	//additions = getAdditions(from, to);
	//deprecate = filterM3(to, elemsDeprecated);
	//return applyMatchers(additions, deprecate, fun, options, DEP_MATCHERS);
}


/*
 * Identifying renamed elements
 */ 
private rel[loc, Mapping[loc]] renamed(M3Diff diff,  Delta delta) {
	diff = filterDiffRenamed(diff, delta);
	removals = diff.removals;
	additions = diff.additions;
	result = {};
	
	for (<cont, elem> <- removals.containment, removals.declarations[elem] != {}, isTargetMember(elem)) {
		// In type cases we need the owner package instead of its compilation unit.
		cont = (isCompilationUnit(cont)) ? getOneFrom(invert(removals.containment)[cont]) : cont;
		elemsSameCont = {};
		
		for (a <- additions.containment[cont], additions.declarations[a] != {}, isTargetMember(a)) {
			a = (isCompilationUnit(a)) ? getOneFrom(additions.containment[a]) : a;
			elemsSameCont += a;
		}
		
		if (elemsSameCont != {}) {
			diffTemp = diff;
			diffTemp.removals = filterM3(removals, {elem});
			diffTemp.additions = filterM3(additions, elemsSameCont);
			result += applyMatchers(diffTemp, isTargetMember, options, MATCHERS);
		}
	}
	return result;
}

private M3Diff filterDiffRenamed(M3Diff diff, Delta delta) {
	elemsRemovals = (!isEmpty(delta.changedParamList)) ? delta.changedParamList.elem : {};
	diff.removals = filterXM3(diff.removals, elemsRemovals);
	return diff;
}


private rel[loc, Mapping[loc]] moved(M3Diff diff, Delta delta) {
	diff = filterDiffMoved(diff, delta);
	removals = diff.removals;
	additions = diff.additions;
	result = {};
	
	for (<cont, elem> <- removals.containment, removals.declarations[elem] != {}, isTargetMember(elem)) {
		diffTemp = diff;
		diffTemp.removals = filterM3(removals, {elem});
		result += applyMatchers(diffTemp, isTargetMember, options, MATCHERS);
	}
	
	return result;
}

private M3Diff filterDiffMoved(M3Diff diff, Delta delta) {
	elemsRemovals 	= ((!isEmpty(delta.renamed)) ? delta.renamed.mapping<0> : {})
					+ ((!isEmpty(delta.changedParamList)) ? delta.changedParamList.elem : {});
	elemsAdditions 	= (!isEmpty(delta.renamed)) ? delta.renamed.mapping<1> : {};
		
	diff.removals = filterXM3(diff.removals, elemsRemovals);
	diff.additions = filterXM3(diff.additions, elemsAdditions);

	return diff;
}

/*
 * Identifying removed elements
 */
// FIXME: match signature?
private rel[loc, Mapping[loc]] removed(M3Diff diff, Delta delta) {
	diff = filterDiffRemoved(diff, delta);
	return 	{ buildMapping(e, e, |unknown:///|, 1.0, MATCH_SIGNATURE) 
			| <_, e> <- diff.removals.containment, isTargetMember(e) };
}
	

private M3Diff filterDiffRemoved(M3Diff diff, Delta delta) {
	elemsRemovals 	= ((!isEmpty(delta.renamed)) ? delta.renamed.mapping<0> : {})
					+ ((!isEmpty(delta.moved)) ? delta.moved.mapping<0> : {})
					+ ((!isEmpty(delta.changedParamList)) ? delta.changedParamList.elem : {});
		
	elemsAdditions 	= ((!isEmpty(delta.renamed)) ? delta.renamed.mapping<1> : {})
					+ ((!isEmpty(delta.moved)) ? delta.moved.mapping<1> : {});
		
	diff.removals = filterXM3(diff.removals, elemsRemovals);
	diff.additions = filterXM3(diff.additions, elemsAdditions);
	
	return diff;
}

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
	methsAdded = { <m, typ> | <m, typ> <- diff.additions.types, isMethod(m) };
	methsRemoved = { <m, typ> | <m, typ> <- diff.removals.types, isMethod(m) };
		
	result = {};
	for (<methAdded, typeAdded> <- methsAdded) {
		for (<methRemoved, typeRemoved> <- methsRemoved, sameMethodQualName(methAdded, methRemoved)) {
			elemsRemoved = fun(typeRemoved);
			elemsAdded = fun(typeAdded);
	
			if (elemsRemoved != elemsAdded) {
				result += buildMapping(methRemoved, elemsRemoved, elemsAdded, 1.0, MATCH_SIGNATURE);
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
				typeAdded != typeRemoved) {
			result += buildMapping(fieldRemoved, typeRemoved, typeAdded, 1.0, MATCH_SIGNATURE);
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
		result += buildMapping(cls, oldSup, newSupLoc, 1.0, MATCH_SIGNATURE);
	}

	for (<cls, newSup> <- diff.additions.extends) {
		oldSup = diff.removals.extends[cls];
		oldSupLoc = size(oldSup) == 1 ? getOneFrom(oldSup) : |unknown:///|;
		result += buildMapping(cls, oldSupLoc, newSup, 1.0, MATCH_SIGNATURE);
	}
	
	return result;
}

rel[loc, Mapping[set[loc]]] changedImplements(M3Diff diff) {
	removals = diff.removals;
	additions = diff.additions;
	
	return { buildMapping(typ,
				removals.implements[typ],
				additions.implements[typ],
				1.0,
				MATCH_SIGNATURE)
			| typ <- domain(removals.implements) + domain(additions.implements) };
}

private bool isTargetMemberExclInterface(loc elem)
	= isClass(elem)
	|| isMethod(elem)
	|| isField(elem);

private bool isTargetMember(loc elem)
	= isTargetMemberExclInterface(elem)
	|| isInterface(elem);

private tuple[loc, Mapping[&T]] buildMapping(loc elem, &T from, &T to, real score, str meth)
	= <elem, <from, to, score, meth>>;

private tuple[loc, Mapping[&T]] buildMapping(loc elem, Mapping[&T] mapping)
	= <elem, mapping>;
	
private bool sameMethodQualName(loc m1, loc m2) {
	m1Name = methodQualName(m1);
	m2Name = methodQualName(m2);
	return m1Name == m2Name;
} 

private str methodQualName(loc m) 
	= (/<mPath: [a-zA-Z0-9.$\/]+>(<mParams: [a-zA-Z0-9.$\/]*>)/ := m.path) ? mPath : "";
	
private str methodName(loc m) 
	= substring(methodQualName(m), (findLast(methodQualName(m), "/") + 1));

private list[TypeSymbol] methodParams(TypeSymbol typ) 
	= (\method(_,_,_,params) := typ) ? params : [];
	
private TypeSymbol methodReturnType(TypeSymbol typ) 
	= (\method(_,_,ret,_) := typ) ? ret : TypeSymbol::\void();


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
