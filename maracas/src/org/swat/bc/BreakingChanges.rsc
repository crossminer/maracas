module org::swat::bc::BreakingChanges

import IO;
import lang::java::m3::AST;
import lang::java::m3::Core;
import Relation;
import Set;

// TODO: check how to manage method, types, fields rename

//----------------------------------------------
// ADT
//----------------------------------------------

// TODO: check if it makes sense to use rel or an alias
data BC = bc (
	Mapping[loc, loc] id,
	ClassBC classBCs = classBc(),
	MethodBC methodBCs = methodBc()
);

data ClassBC = classBc (
	GenericBC genericBCs = genericBc()
);

data MethodBC = methodBc (
	rel[loc, Mapping[list[TypeSymbol], list[TypeSymbol]]] changedParams = {},
	rel[loc, Mapping[TypeSymbol, TypeSymbol]] changedReturnTypes = {},
	GenericBC genericBCs = genericBc()
);

data GenericBC = genericBc (
	rel[loc elem, Mapping[Modifier,Modifier] mapping] changedAccess = {},
	set[loc elem] final = {},
	rel[loc elem, Mapping[loc, loc] mapping] moved = {},
	rel[loc elem, Mapping[loc,loc] mapping] removed = {},
	rel[loc elem, Mapping[str, str] mapping] renamed = {}
);

alias Mapping[&T, &U] = tuple[&T from, &U to];

data BCType
	= classBC()
	| methodBC()
	;


//----------------------------------------------
// Builder
//----------------------------------------------

@memo
M3 getRemovals(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3Old, m3New]);

@memo
M3 getAdditions(M3 m3Old, M3 m3New) = diffJavaM3(m3Old.id, [m3New, m3Old]);


BC createBC(M3 m3Old, M3 m3New) {
	id = createBCId(m3Old, m3New);
	cBCs = createClassBCs(m3Old, m3New);
	mBCs = createMethodBCs(m3Old, m3New);
	return bc(id, classBCs=cBCs, methodBCs=mBCs); 
}

private Mapping[loc,loc] createBCId(M3 m3Old, M3 m3New) = <m3Old.id, m3New.id>;

private ClassBC createClassBCs(M3 m3Old, M3 m3New) {
	gBCs =  createGenericBCs(m3Old, m3New, classBC());
	return classBc(genericBCs=gBCs);
}

private MethodBC createMethodBCs(M3 m3Old, M3 m3New) {
	gBCs =  createGenericBCs(m3Old, m3New, methodBC());
	return methodBc(
			changedParams=changedParams(m3Old, m3New),
			changedReturnTypes=changedReturnType(m3Old, m3New),
			genericBCs=gBCs);
}

private GenericBC createGenericBCs(M3 m3Old, M3 m3New, BCType typ) 
	= genericBc(
		changedAccess = changedAccess(m3Old, m3New, typ),
		final = addedFinal(m3Old, m3New, typ),
		//TODO: moved
		removed = removedElems(m3Old, m3New, typ)
		//TODO: renamed
	);



// TODO: manage package modifier.
private rel[loc, Mapping[Modifier, Modifier]] changedAccess(M3 m3Old, M3 m3New, classBC()) = changedAccess(m3Old, m3New, isClass);
private rel[loc, Mapping[Modifier, Modifier]] changedAccess(M3 m3Old, M3 m3New, methodBC()) = changedAccess(m3Old, m3New, isMethod);

private rel[loc, Mapping[Modifier,Modifier]] changedAccess(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Adds = getAdditions(m3Old, m3New);
	m3Rems = getRemovals(m3Old, m3New);
	
	// Get acces modifiers
	accMods = {\public(), \private(), \protected()};
	newElems = {<e,m> | <e,m> <- m3Adds.modifiers, fun(e), m in accMods};
	oldElems = {<e,m> | <e,m> <- m3Rems.modifiers, fun(e), m in accMods};
	
	elems = domain(newElems);
	return {<e, <getFirstFrom(oldElems[e]), getFirstFrom(newElems[e])>> | e <- elems, oldElems[e] != {}, newElems[e] != oldElems[e]};
}


private set[loc] addedFinal(M3 m3Old, M3 m3New, classBC()) = addedFinal(m3Old, m3New, isClass);
private set[loc] addedFinal(M3 m3Old, M3 m3New, methodBC()) = addedFinal(m3Old, m3New, isMethod);

private set[loc] addedFinal(M3 m3Old, M3 m3New, bool (loc) fun) {
	m3Diff = getAdditions(m3Old, m3New);	
	return {e | <e,m> <- m3Diff.modifiers, m := \final(), fun(e)};
}


private rel[loc, Mapping[loc,loc]] removedElems(M3 m3Old, M3 m3New, classBC()) {
	m3Old.containment = m3Old.containment+;
	m3New.containment = m3New.containment+;
	m3Diff = getRemovals(m3Old, m3New);	
	return {<c, <p,c>> | <p,c> <- m3Diff.containment, isPackage(p), isClass(c) || isInterface(c)};
}

private rel[loc, Mapping[loc,loc]] removedElems(M3 m3Old, M3 m3New, methodBC()) {
	m3Diff = getRemovals(m3Old, m3New);	
	return {<m, <c,m>> | <c,m> <- m3Diff.containment, isClass(c) || isInterface(c)};
}


rel[loc, Mapping[list[TypeSymbol],list[TypeSymbol]]] changedParams(M3 m3Old, M3 m3New) 
	= changedMethodSignature(m3Old, m3New, methodParams);

rel[loc, Mapping[TypeSymbol,TypeSymbol]] changedReturnType(M3 m3Old, M3 m3New)
	= changedMethodSignature(m3Old, m3New, methodReturnType);
	
private rel[loc, Mapping[&T,&T]] changedMethodSignature(M3 m3Old, M3 m3New, &T (&U) fun) {
	m3Adds = getAdditions(m3Old, m3New);
	m3Rems = getRemovals(m3Old, m3New);
	
	// Get modified methods' type dependencies	
	newMeths = {<m,t> | <m,t> <- m3Adds.types, isMethod(m) || isConstructor(m)};
	oldMeths = {<m,t> | <m,t> <- m3Rems.types, isMethod(m) || isConstructor(m)};
	
	result = {};
	for(<newMeth, newType> <- newMeths) {
		for(<oldMeth, oldType> <- oldMeths, sameMethodName(newMeth,oldMeth)) {
			newElems = fun(newType);
			oldElems = fun(oldType);
			
			if(oldElems != newElems) {
					result += <newMeth, <oldElems, newElems>>;
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