module org::maracas::m3::Inheritance

import lang::java::m3::AST;
import lang::java::m3::Core;

import org::maracas::m3::Core;

import IO;
import Relation;

@doc{
	Creates a contained entity logical location given the logical
	location of a parent class, the entity scheme and its name.
	
	@param class: logical location of parent class
	@param scheme: scheme of the entity
	@param fieldName: string representing the name of the 
	       field
}
loc createContainedLoc(loc class, str scheme, str fieldName) {
	loc l = class;
	l.path = "<class.path>/<fieldName>";
	l.scheme = scheme;
	return l;
}

bool hasSupertypesWithShadowing(loc class, str scheme, str elemName, M3 m) {
	set[loc] symbRefs = createSupertypeSymbRefs(class, scheme, elemName, m);
	
	if (loc s <- symbRefs, m.declarations[s] != {}) {
		return true;
	}
	else {
		return false;
	}
}

bool hasSubtypesWithShadowing(loc class, str scheme, str elemName, M3 api) {
	set[loc] symbRefs = createSubtypeSymbRefs(class, scheme, elemName, api);
	
	if (loc s <- symbRefs, api.declarations[s] != {}) {
		return true;
	}
	else {
		return false;
	}
}

private set[loc] getSubtypesWithoutShadowing(loc class, str scheme, str elemName, M3 m) {
	set[loc] subtypes = m.invertedExtends[class] + m.invertedImplements[class];
	
	return { *(getSubtypesWithoutShadowing(s, scheme, elemName, m) + s) 
		| s <- subtypes, m.declarations[createContainedLoc(s, scheme, elemName)] == {} }
		+ class;
}

private set[loc] getHierarchyWithoutShadowing(loc class, str scheme, str elemName, M3 api, M3 client) {
	set[loc] apiSubtypes = getSubtypesWithoutShadowing(class, scheme, elemName, api);
	return { *getSubtypesWithoutShadowing(s, scheme, elemName, client) | s <- apiSubtypes }
		+ apiSubtypes;
}
	
set[loc] getHierarchyWithoutMethShadowing(loc class, str scheme, str signature, M3 api, M3 client) 
	= getHierarchyWithoutShadowing(class, scheme, signature, api, client);

@doc{
	Given a type and the name of a member within that 
	type, the function computes all symbolic references of
	the member. These references are computed by gathering
	all subtypes of the input type that do not shadow the 
	method. To perform this operation a function that computes 
	the symbolic reference of the member should be provided 
	(cf. createSymbRef).
	
	@param class: logical location of parent class
	@param elemName: string representing the name of the 
	       member
	@param m: M3 owning the main types and its subtypes
	@param createSymbRef: function that computes the symbolic
	       reference of the member gicen the logical location 
	       of a type and the member's name.
}
set[loc] createHierarchySymbRefs(loc class, str scheme, str elemName, M3 api, M3 client, bool allowShadowing = false, bool includeParent = true) {
	set[loc] apiSubtypes = {};
	set[loc] clientSubtypes = {};
	
	if (!allowShadowing) {
		apiSubtypes = getSubtypesWithoutShadowing(class, scheme, elemName, api);
		clientSubtypes = { *getSubtypesWithoutShadowing(s, scheme, elemName, client) | s <- apiSubtypes };
	}
	else {
		apiSubtypes = getSubtypes(class, api) + class;
		clientSubtypes = { *getSubtypes(s, client) | s <- apiSubtypes };
	}
	
	if (!includeParent) {
		apiSubtypes = apiSubtypes - class;
		clientSubtypes = clientSubtypes - class;
	}
	return { createContainedLoc(c, scheme, elemName) | c <- apiSubtypes + clientSubtypes };
}

set[loc] createSupertypeSymbRefs(loc class, str scheme, str elemName, M3 api) {
	res = { createContainedLoc(s, scheme, elemName) | s <- getSupertypes(class, api) };
	return res;
}

set[loc] createSubtypeSymbRefs(loc class, str scheme, str elemName, M3 api) {
	res = { createContainedLoc(s, scheme, elemName) | s <- getSubtypes(class, api) };
	return res;
}

set[loc] getSupertypes(loc class, M3 m) 
	= (m.extends+ + m.implements+)[class];
	

@doc{
	Returns a set of locations pointing to the subtypes 
	of a class given by parameter. The M3 model owning
	the type is needed to gather all subtypes.
	
	@param class: logical location of the main type
	@param m: M3 model owning the main type and all its 
	       subtypes
}
set[loc] getSubtypes(loc class, M3 m)
	= m.invertedExtends[class] + m.invertedImplements[class];
	
@doc{ 
	Returns a set of locations pointing to the ABSTRACT
	subtypes of a class given by parameter. The M3 model 
	owning the type is needed to gather all subtypes.
	
	@param class: logical location of the main type
	@param m: M3 model owning the main type and all its 
	       subtypes
}
set[loc] getAbstractSubtypes(loc class, M3 m) 
	= domain((getSubtypes(class, m) * { \abstract() }) & m.modifiers);

@doc{
	Returns a set of locations pointing to the CONCRETE
	subtypes of a class given by parameter. The M3 model 
	owning the type is needed to gather all subtypes.
	
	@param class: logical location of the main type
	@param m: M3 model owning the main type and all its 
	       subtypes
}
set[loc] getConcreteSubtypes(loc class, M3 m) 
	= getSubtypes(class, m) - getAbstractSubtypes(class, m);

@doc{
	Given a type declared in an API M3 model the 
	function returns all its direct and transitive 
	subtypes in a client M3 model.
	
	@param class: logical location of the main API type
	@param api: API M3 model owning the main type
	@param client: client M3 model owning extracted 
	       subtypes
}
set[loc] getClientSubtypes(loc class, M3 api, M3 client) {
	set[loc] apiSubtypes = getSubtypes(class, api) + class;
	return { *getSubtypes(s, client) | s <- apiSubtypes };
}

@doc{ 
	Given a type declared in an API M3 model the 
	function returns all its direct and transitive 
	ABSTRACT subtypes in a client M3 model.
	
	@param class: logical location of the main API type
	@param api: API M3 model owning the main type
	@param client: client M3 model owning extracted 
	       subtypes
}
set[loc] getClientAbstractSubtypes(loc class, M3 api, M3 client) {
	set[loc] clientSubs = getClientSubtypes(class, api, client);
	return domain((clientSubs * { \abstract() }) & client.modifiers);
}

@doc{
	Given a type declared in an API M3 model the 
	function returns all its direct and transitive 
	CONCRETE subtypes in a client M3 model.
	
	@param class: logical location of the main API type
	@param api: API M3 model owning the main type
	@param client: client M3 model owning extracted 
	       subtypes
}
set[loc] getClientConcreteSubtypes(loc class, M3 api, M3 client)
	= getClientSubtypes(class, api, client) - getClientAbstractSubtypes(class, api, client);
	
M3 filterConstructorOverride(M3 m) {
	m.methodOverrides = { <from, to> | <loc from, loc to> <- m.methodOverrides, !(isConstructor(from) && isConstructor(to)) };
	return m;
}