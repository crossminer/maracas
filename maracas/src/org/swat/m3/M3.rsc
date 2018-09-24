module org::swat::m3::M3

import IO;
import lang::java::m3::AST;
import lang::java::m3::Core;
import Relation;
import Set;

// TODO: check how to manage method, types, fields rename

@memo
M3 getRemovals(loc id, M3 m3Old, M3 m3New) = diffJavaM3(id, [m3Old, m3New]);

@memo
M3 getAdditions(loc id, M3 m3Old, M3 m3New) = diffJavaM3(id, [m3New, m3Old]);


set[loc] addedFinalModifiers2Type(loc id, M3 m3Old, M3 m3New) = addedFinalModifiers(id, m3Old, m3New, isClass);
set[loc] addedFinalModifiers2Method(loc id, M3 m3Old, M3 m3New) = addedFinalModifiers(id, m3Old, m3New, isMethod);

private set[loc] addedFinalModifiers(loc id, M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Diff = getAdditions(id, m3Old, m3New);	
	return {e | <e,m> <- m3Diff.modifiers, m := \final(), fun(e)};
}

// TODO: manage package modifier.
rel[loc,Modifier,Modifier] changedAccessModifiers2Type(loc id, M3 m3Old, M3 m3New) = changedAccessModifiers(id, m3Old, m3New, isClass);
rel[loc,Modifier,Modifier] changedAccessModifiers2Method(loc id, M3 m3Old, M3 m3New) = changedAccessModifiers(id, m3Old, m3New, isMethod);

private rel[loc,Modifier,Modifier] changedAccessModifiers(loc id, M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Adds = getAdditions(id, m3Old, m3New);
	m3Rems = getRemovals(id, m3Old, m3New);
	
	// Get acces modifiers
	accMods = {\public(), \private(), \protected()};
	newElems = {<e,m> | <e,m> <- m3Adds.modifiers, fun(e), m in accMods};
	oldElems = {<e,m> | <e,m> <- m3Rems.modifiers, fun(e), m in accMods};
	
	elems = domain(newElems);
	return {<e, getFirstFrom(oldElems[e]), getFirstFrom(newElems[e])> | e <- elems, oldElems[e] != {}, newElems[e] != oldElems[e]};
}

rel[loc,loc] removedMethods(loc id, M3 m3Old, M3 m3New) {
	m3Diff = getRemovals(id, m3Old, m3New);	
	return {<c,m> | <c,m> <- m3Diff.containment, isClass(c) || isInterface(c)};
}

rel[loc,loc] removedClass(loc id, M3 m3Old, M3 m3New) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	m3Diff = getRemovals(id, m3Old, m3New);	
	return {<p,c> | <p,c> <- m3Diff.containment, isPackage(p), isClass(c) || isInterface(c)};
}

rel[loc,list[TypeSymbol],list[TypeSymbol]] changedParams(loc id, M3 m3Old, M3 m3New) 
	= changedMethodSignature(id, m3Old, m3New, methodParams);

rel[loc,TypeSymbol,TypeSymbol] changedReturnType(loc id, M3 m3Old, M3 m3New)
	=changedMethodSignature(id, m3Old, m3New, methodReturnType);
	
private rel[loc,&T,&T] changedMethodSignature(loc id, M3 m3Old, M3 m3New, &T (&U) fun) {
	m3Adds = getAdditions(id, m3Old, m3New);
	m3Rems = getRemovals(id, m3Old, m3New);
	
	// Get modified methods' type dependencies	
	newMeths = {<m,t> | <m,t> <- m3Adds.types, isMethod(m) || isConstructor(m)};
	oldMeths = {<m,t> | <m,t> <- m3Rems.types, isMethod(m) || isConstructor(m)};
	
	result = {};
	for(<newMeth, newType> <- newMeths) {
		for(<oldMeth, oldType> <- oldMeths, sameMethodName(newMeth,oldMeth)) {
			newElems = fun(newType);
			oldElems = fun(oldType);
			
			if(oldElems != newElems) {
					result += <newMeth, oldElems, newElems>;
			}
		}
	}
	return result;
}

private bool sameMethodName(loc m1, loc m2) {
	m1Name = methodName(m1);
	m2Name = methodName(m2);
	return m1Name == m2Name;
}

private str methodName(loc m) = (/<mPath: [a-zA-Z0-9.$\/]+>(<mParams: [a-zA-Z0-9.$\/]*>)/ := m.path) ? mPath : "";
private list[TypeSymbol] methodParams(TypeSymbol typ) = (\method(_,_,_,params) := typ) ? params : [];
private TypeSymbol methodReturnType(TypeSymbol typ) = (\method(_,_,ret,_) := typ) ? ret : \void();