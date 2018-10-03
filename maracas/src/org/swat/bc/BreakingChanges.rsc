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

// TODO: check if it makes sense to use rel or an alias
data BreakingChanges (
	rel[loc elem, Mapping[Modifier, Modifier] mapping] changedAccessModifier = {},
	rel[loc elem, Mapping[Modifier, Modifier] mapping] changedFinalModifier = {},
	rel[loc elem, Mapping[loc, loc] mapping] moved = {},
	rel[loc elem, Mapping[loc, loc] mapping] removed = {},
	rel[loc elem, Mapping[loc, loc] mapping] renamed = {})
	= class (
		Mapping[loc, loc] id)
	| method (
		Mapping[loc, loc] id,
		rel[loc elem, Mapping[list[TypeSymbol], list[TypeSymbol]] mapping] changedParamList = {},
		rel[loc elem, Mapping[TypeSymbol, TypeSymbol] mapping] changedReturnType = {})
	;

alias Mapping[&T, &T] = tuple[&T from, &T to];
	

//----------------------------------------------
// Builder
//----------------------------------------------

@memo M3 getRemovals(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3Old, m3New]);
@memo M3 getAdditions(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3New, m3Old]);

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

private Mapping[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;

private BreakingChanges addCoreBCs(M3 m3Old, M3 m3New, BreakingChanges bc) {
	bc.changedAccessModifier = changedAccessModifier(m3Old, m3New, bc);
	bc.changedFinalModifier = changedFinalModifier(m3Old, m3New, bc);
	//TODO: moved
	bc.removed = removedElems(m3Old, m3New, bc);
	bc.renamed = renamedElems(m3Old, m3New, bc);
	return bc;
}

/*
 * Identifying changes in access modifiers
 */
// TODO: manage package modifier.
private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, \class(_)) = changedAccessModifier(m3Old, m3New, isClass);
private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, \method(_)) = changedAccessModifier(m3Old, m3New, isMethod);

private rel[loc, Mapping[Modifier, Modifier]] changedAccessModifier(M3 m3Old, M3 m3New, bool (loc) fun) {
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
private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, \class(_)) = changedFinalModifier(m3Old, m3New, isClass);
private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, \method(_)) = changedFinalModifier(m3Old, m3New, isMethod);

private rel[loc, Mapping[Modifier, Modifier]] changedFinalModifier(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Adds = getAdditions(m3Old, m3New);
	m3Rems = getRemovals(m3Old, m3New);	
	return {<e, <\default(), m>> | <e,m> <- m3Adds.modifiers, m := \final(), fun(e)}
		+ {<e, <m, \default()>> | <e,m> <- m3Rems.modifiers, m := \final(), fun(e)};
}

/*
 * Identifying removed elements
 */
private rel[loc, Mapping[loc, loc]] removedElems(M3 m3Old, M3 m3New, \class(_)) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	m3Diff = getRemovals(m3Old, m3New);	
	return {<c, <p,c>> | <p,c> <- m3Diff.containment, isPackage(p), isClass(c) || isInterface(c)};
}

private rel[loc, Mapping[loc, loc]] removedElems(M3 m3Old, M3 m3New, \method(_)) {
	m3Diff = getRemovals(m3Old, m3New);	
	return {<m, <c,m>> | <c,m> <- m3Diff.containment, isClass(c) || isInterface(c)};
}

/*
 * Identifying renamed elements
 */
private rel[loc, Mapping[loc, loc]] renamedElems(M3 m3Old, M3 m3New, \class(_)) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	return renamedElems(m3Old, m3New, isClass);
}
private rel[loc, Mapping[loc, loc]] renamedElems(M3 m3Old, M3 m3New, \method(_)) = renamedElems(m3Old, m3New, isMethod);

private rel[loc, Mapping[loc, loc]] renamedElems(M3 m3Old, M3 m3New, bool (loc) fun) {
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
				result += <r, <r, a>>;
				continue;
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
	switch(bc) {
		case \method() : return postprocMethodBC(bc);
		default : return bc; 
	}
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