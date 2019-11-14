module org::maracas::m3::Inheritance

import lang::java::m3::AST;
import lang::java::m3::Core;

import IO;
import Relation;

@doc{
	Creates a field logical location given the logical
	location of a parent class and the name of the field.
	
	@param class: logical location of parent class
	@param fieldName: string representing the name of the 
	       field
}
loc createFieldLoc(loc class, str fieldName)
	= |java+field:///| + "<class.path>/<fieldName>";

@doc{ 
	Creates a method logical location given the logical
	location of a parent class and the name of the method.
	
	@param class: logical location of parent class
	@param fieldName: string representing the name of the 
	       method
}
loc createMethodLoc(loc class, str methName)
	= |java+method:///| + "<class.path>/<methName>";
	

private set[loc] getSubtypesWithoutShadowing(loc class, str elemName, M3 m, loc (loc, str) createSymbRef) {
	set[loc] subtypes = domain(rangeR(m.extends, { class })) + domain(rangeR(m.implements, { class }));
	
	return { *(getSubtypesWithoutShadowing(s, elemName, m, createSymbRef) + s) 
		| s <- subtypes, m.declarations[createSymbRef(s, elemName)] == {} }
		+ class;
}

set[loc] getFieldSubsWithoutShadowing(loc class, str fieldName, M3 m)
	= getSubtypesWithoutShadowing(class, fieldName, m, createFieldLoc);
	
set[loc] getMethSubsWithoutShadowing(loc class, str signature, M3 m)
	= getSubtypesWithoutShadowing(class, signature, m, createMethodLoc);

private set[loc] getHierarchyWithoutShadowing(loc class, str elemName, M3 api, M3 client, loc (loc, str) createSymbRef) {
	set[loc] apiSubtypes = getSubtypesWithoutShadowing(class, elemName, api, createSymbRef);
	return { *getSubtypesWithoutShadowing(s, elemName, client, createSymbRef) | s <- apiSubtypes }
		+ apiSubtypes;
}
	
set[loc] getHierarchyWithoutMethShadowing(loc class, str signature, M3 api, M3 client) 
	= getHierarchyWithoutShadowing(class, signature, api, client, createMethodLoc);

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
private set[loc] createHierarchySymbRefs(loc class, str elemName, M3 api, M3 client, loc (loc, str) createSymbRef, bool allowShadowing, bool includeParent) {
	set[loc] apiSubtypes = {};
	set[loc] clientSubtypes = {};
	
	if (!allowShadowing) {
		apiSubtypes = getSubtypesWithoutShadowing(class, elemName, api, createSymbRef);
		clientSubtypes = { *getSubtypesWithoutShadowing(s, elemName, client, createSymbRef) | s <- apiSubtypes };
	}
	else {
		apiSubtypes = getSubtypes(class, api) + class;
		clientSubtypes = { *getSubtypes(s, client) | s <- apiSubtypes };
	}
	
	if (!includeParent) {
		apiSubtypes = apiSubtypes - class;
		clientSubtypes = clientSubtypes - class;
	}
	return { createSymbRef(c, elemName) | c <- apiSubtypes + clientSubtypes };
}

@doc{
	Given a type and the name of a field within that type, 
	the function computes all symbolic references of the 
	method. These references are computed by gathering all 
	subtypes of the input type that do not shadow the field. 
	
	@param class: logical location of parent class
	@param fieldName: string representing the name of the
	       field
	@param m: M3 owning the main types and its subtypes
}
set[loc] createHierarchyFieldSymbRefs(loc class, str fieldName, M3 api, M3 client, bool includeParent = true)
	= createHierarchySymbRefs(class, fieldName, api, client, createFieldLoc, false, includeParent);

@doc{
	Given a type and the signature of a method within that 
	type, the function computes all symbolic references of
	the method. These references are computed by gathering
	all subtypes of the input type that do not shadow/override 
	the method. 
	
	@param class: logical location of parent class
	@param signature: string representing the signature of 
	       the method
	@param m: M3 owning the main types and its subtypes
}
set[loc] createHierarchyMethSymbRefs(loc class, str signature, M3 api, M3 client, bool allowShadowing = false, bool includeParent = true)
	= createHierarchySymbRefs(class, signature, api, client, createMethodLoc, allowShadowing, includeParent);

@doc{
	Returns a set of locations pointing to the subtypes 
	of a class given by parameter. The M3 model owning
	the type is needed to gather all subtypes.
	
	@param class: logical location of the main type
	@param m: M3 model owning the main type and all its 
	       subtypes
}
set[loc] getSubtypes(loc class, M3 m) 
	= invert(m.extends+) [class] + invert(m.implements+) [class];

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