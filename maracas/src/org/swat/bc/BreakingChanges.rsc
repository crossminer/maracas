module org::swat::bc::BreakingChanges

import IO;
import lang::java::m3::AST;
import lang::java::m3::Core;
import org::swat::bc::CodeSimilarity;
import Relation;
import Set;
import String;


//----------------------------------------------
// ADT
//----------------------------------------------

//// TODO: check if it makes sense to use rel or an alias
data BreakingChanges (
	rel[loc elem, Mapping[Modifier, Modifier] mapping] changedAccess = {},
	set[loc elem] final = {},
	rel[loc elem, Mapping[loc, loc] mapping] moved = {},
	rel[loc elem, Mapping[loc, loc] mapping] removed = {},
	rel[loc elem, Mapping[str, str] mapping] renamed = {})
	= class (
		Mapping[loc, loc] id,
		BCType \type = classBC())
	| method (
		Mapping[loc, loc] id,
		BCType \type = methodBC(), 
		rel[loc, Mapping[list[TypeSymbol], list[TypeSymbol]]] changedParams = {},
		rel[loc, Mapping[TypeSymbol, TypeSymbol]] changedReturnTypes = {})
	;

data BCType
	= classBC()		// Class type
	| methodBC()	// Method type
	;

alias Mapping[&T, &U] = tuple[&T from, &U to];


//----------------------------------------------
// Builder
//----------------------------------------------

@memo M3 getRemovals(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3Old, m3New]);
@memo M3 getAdditions(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3New, m3Old]);

@memo
BreakingChanges createClassBC(M3 m3Old, M3 m3New) {
	id = createBCId(m3Old, m3New);
	bc = class(id);
	return addCoreBCs(m3Old, m3New, bc);
}

@memo
BreakingChanges createMethodBC(M3 m3Old, M3 m3New) {
	id = createBCId(m3Old, m3New);
	bc = method(id);
	bc.changedParams = changedParams(m3Old, m3New);
	bc.changedReturnTypes = changedReturnType(m3Old, m3New);
	return addCoreBCs(m3Old, m3New, bc);
}

private Mapping[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;

private BreakingChanges addCoreBCs(M3 m3Old, M3 m3New, BreakingChanges bc) {
	bc.changedAccess = changedAccess(m3Old, m3New, bc.\type);
	bc.final = addedFinal(m3Old, m3New, bc.\type);
	//TODO: moved
	bc.removed = removedElems(m3Old, m3New, bc.\type);
	bc.renamed = renamedElems(m3Old, m3New, bc.\type);
	return bc;
}

/*
 * Identifying changes in access modifiers
 */
// TODO: manage package modifier.
private rel[loc, Mapping[Modifier, Modifier]] changedAccess(M3 m3Old, M3 m3New, classBC()) = changedAccess(m3Old, m3New, isClass);
private rel[loc, Mapping[Modifier, Modifier]] changedAccess(M3 m3Old, M3 m3New, methodBC()) = changedAccess(m3Old, m3New, isMethod);

private rel[loc, Mapping[Modifier, Modifier]] changedAccess(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Adds = getAdditions(m3Old, m3New);
	m3Rems = getRemovals(m3Old, m3New);
	
	accMods = {\public(), \private(), \protected()};
	newElems = {<e,m> | <e,m> <- m3Adds.modifiers, fun(e), m in accMods};
	oldElems = {<e,m> | <e,m> <- m3Rems.modifiers, fun(e), m in accMods};
	
	elems = domain(newElems);
	return {<e, <getFirstFrom(oldElems[e]), getFirstFrom(newElems[e])>> | e <- elems, oldElems[e] != {}, newElems[e] != oldElems[e]};
}


/*
 * Identifying additions of final modifiers
 */
private set[loc] addedFinal(M3 m3Old, M3 m3New, classBC()) = addedFinal(m3Old, m3New, isClass);
private set[loc] addedFinal(M3 m3Old, M3 m3New, methodBC()) = addedFinal(m3Old, m3New, isMethod);

private set[loc] addedFinal(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Diff = getAdditions(m3Old, m3New);	
	return {e | <e,m> <- m3Diff.modifiers, m := \final(), fun(e)};
}

/*
 * Identifying removed elements
 */
private rel[loc, Mapping[loc, loc]] removedElems(M3 m3Old, M3 m3New, classBC()) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	m3Diff = getRemovals(m3Old, m3New);	
	return {<c, <p,c>> | <p,c> <- m3Diff.containment, isPackage(p), isClass(c) || isInterface(c)};
}

private rel[loc, Mapping[loc, loc]] removedElems(M3 m3Old, M3 m3New, methodBC()) {
	m3Diff = getRemovals(m3Old, m3New);	
	return {<m, <c,m>> | <c,m> <- m3Diff.containment, isClass(c) || isInterface(c)};
}

/*
 * Identifying renamed elements
 */
private rel[loc, Mapping[str, str]] renamedElems(M3 m3Old, M3 m3New, classBC()) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	return renamedElems(m3Old, m3New, isClass);
}
private rel[loc, Mapping[str, str]] renamedElems(M3 m3Old, M3 m3New, methodBC()) = renamedElems(m3Old, m3New, isMethod);

private rel[loc, Mapping[str, str]] renamedElems(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Adds = getAdditions(m3Old, m3New);
	m3Rems = getRemovals(m3Old, m3New);
	
	comp = invert(m3Rems.containment) o m3Adds.containment;
	rel[loc rem, loc add] candidates = {<r, a> | <r, a> <- comp, fun(r) && fun(a)};
	
	real simThreshold = 0.7;
	result = {};
	for(r <- candidates.rem) {
		for(a <- candidates[r]) {
			str snippet1 = readFile(getFirstFrom(m3Rems.declarations[r]));
			str snippet2 = readFile(getFirstFrom(m3Adds.declarations[a]));
			
			// Hard assumption: Assuming that the first match is the right one
			if(codeIsSimilar(snippet1, snippet2, simThreshold)) {
				result += <r, <methodName(r), methodName(a)>>;
				continue;
			}
		}
	}
	return result;
}


/*
 * Identifying changes in method parameter lists
 */
private rel[loc, Mapping[list[TypeSymbol], list[TypeSymbol]]] changedParams(M3 m3Old, M3 m3New) 
	= changedMethodSignature(m3Old, m3New, methodParams);

/*
 * Identifying changes in method return types
 */
private rel[loc, Mapping[TypeSymbol, TypeSymbol]] changedReturnType(M3 m3Old, M3 m3New)
	= changedMethodSignature(m3Old, m3New, methodReturnType);
	
private rel[loc, Mapping[&T, &T]] changedMethodSignature(M3 m3Old, M3 m3New, &T (&U) fun) {
	m3Adds = getAdditions(m3Old, m3New);
	m3Rems = getRemovals(m3Old, m3New);
	
	newMeths = {<m,t> | <m,t> <- m3Adds.types, isMethod(m) || isConstructor(m)};
	oldMeths = {<m,t> | <m,t> <- m3Rems.types, isMethod(m) || isConstructor(m)};
	
	result = {};
	for(<newMeth, newType> <- newMeths) {
		for(<oldMeth, oldType> <- oldMeths, sameMethodQualName(newMeth,oldMeth)) {
			newElems = fun(newType);
			oldElems = fun(oldType);
			
			if(oldElems != newElems) {
					result += <newMeth, <oldElems, newElems>>;
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