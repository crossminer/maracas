module org::maracas::delta::JApiCmpDetector

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;
import Relation;
import Set;
import IO;


//----------------------------------------------
// ADT
//----------------------------------------------

data Detection = detection (
	loc elem,
	loc used,
	APIUse use,
	CompatibilityChange change
);

data APIUse
	= methodInvocation()
	| methodOverride()
	| fieldAccess() 
	| extends()
	| implements()
	| annotation()
	| typeDependency()
	;

alias ModifiedEntity 
	= tuple[loc elem, CompatibilityChange change];

//----------------------------------------------
// Functions
//----------------------------------------------

@doc {
	Returns a relation mapping API entities that have been
	modified to the type of compatibility change they experienced.
	It consdiers a list of API entities as input (a.k.a. API delta).
	
	@param delta: list of modified APIEntities between two versions 
	       of the target API.
	@return relation mapping modified API entities to compatibility
	        change types (e.g. renamedMethod())
}
set[ModifiedEntity] modifiedEntities(list[APIEntity] delta) 
	= { *modifiedEntities(entity) | entity <- delta };

@doc {
	Returns a relation mapping API entities that have been
	modified to the type of compatibility change they experienced.
	It only considers one API entity as input.
	
	@param entity: modified API entity between two versions of the 
	       target API.
	@return relation mapping modified API entities to compatibility
	        change types (e.g. renamedMethod())
}
set[ModifiedEntity] modifiedEntities(APIEntity entity) {
	set[ModifiedEntity] modified = {};
	visit (entity) {
	case /c:class(id,_,_,chs,_): 
		modified = addModifiedElement(id, modified, chs);
	case /i:interface(id,chs,_):
		modified = addModifiedElement(id, modified, chs);
	case /f:field(id,_,_,chs,_): 
		modified = addModifiedElement(id, modified, chs);
	case /m:method(id,_,_,chs,_): 
		modified = addModifiedElement(id, modified, chs);
	case /c:constructor(id,_,chs,_): 
		modified = addModifiedElement(id, modified, chs);
	}
	return modified;
}

set[ModifiedEntity] filterModifiedEntities(set[ModifiedEntity] entities, CompatibilityChange change) 
	= { <e, ch> | <e, ch> <- entities, ch := change}; 
	
@doc {
	Adds new tuples to a relation mapping API modified entities
	to compatibility change types. These tuples map the element
	location given as parameter to the list of given compatibility 
	changes.
	
	@param element: location to be included in the modElements 
	       relation
	@param modElements: relation mapping modified API entities  
	       to the type of experienced change
	@param changes: list of API change types that should be related
	       to the element location
	@return relation mapping an element location to compatibility
	        change types (e.g. renamedMethod())
}
private set[ModifiedEntity] addModifiedElement(loc element, set[ModifiedEntity] modElements, list[CompatibilityChange] changes)
	= { <element, c> | c <- changes } + modElements;

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta) 
 	= detections(client, oldAPI, delta, annotationDeprecatedAdded())
 	+ detections(client, oldAPI, delta, fieldLessAccessible())
 	+ detections(client, oldAPI, delta, fieldNoLongerStatic())
 	+ detections(client, oldAPI, delta, fieldNowFinal())
 	+ detections(client, oldAPI, delta, fieldNowStatic())
 	+ detections(client, oldAPI, delta, fieldRemoved())
 	+ detections(client, oldAPI, delta, fieldTypeChanged())
 	+ detections(client, oldAPI, delta, methodAbstractAddedInSuperclass())
 	+ detections(client, oldAPI, delta, methodLessAccessible())
 	+ detections(client, oldAPI, delta, methodNoLongerStatic())
 	+ detections(client, oldAPI, delta, methodNowAbstract())
 	+ detections(client, oldAPI, delta, methodNowFinal())
 	+ detections(client, oldAPI, delta, methodNowStatic())
 	+ detections(client, oldAPI, delta, methodNowThrowsCheckedException())
 	+ detections(client, oldAPI, delta, methodRemoved())
 	+ detections(client, oldAPI, delta, methodReturnTypeChanged())
 	+ detections(client, oldAPI, delta, constructorLessAccessible())
 	+ detections(client, oldAPI, delta, constructorRemoved())
 	//+ detections(client, oldAPI, delta, classLessAccessible())
 	+ detections(client, oldAPI, delta, classNoLongerPublic())
 	+ detections(client, oldAPI, delta, classNowAbstract())
 	+ detections(client, oldAPI, delta, classNowCheckedException())
 	+ detections(client, oldAPI, delta, classNowFinal())
 	+ detections(client, oldAPI, delta, classRemoved())
 	+ detections(client, oldAPI, delta, classTypeChanged())
 	+ detections(client, oldAPI, newAPI, delta, fieldStaticAndOverridesStatic())
 	+ detections(client, oldAPI, newAPI, delta, methodAbstractNowDefault())
 	+ detections(client, oldAPI, newAPI, delta, methodAbstractAddedToClass())
 	+ detections(client, oldAPI, newAPI, delta, methodAddedToInterface())
 	+ detections(client, oldAPI, newAPI, delta, methodNewDefault())
 	;
 	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::annotationDeprecatedAdded()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[ModifiedEntity] modifiedMeths = transitiveMethods(oldAPI, modified);
	set[ModifiedEntity] modifiedFields = transitiveEntities(oldAPI, modified);
	return symbMethodDetectionsWithParent(client, oldAPI, modifiedMeths, { methodInvocation(), methodOverride() })
		+ symbFieldDetections(client, oldAPI, modifiedFields, { fieldAccess() })
		+ detectionsAllUses(client, modified);
}

private set[ModifiedEntity] transitiveEntities(M3 oldAPI, set[ModifiedEntity] modified, bool (loc) fun) {
	rel[loc, loc] transContain = oldAPI.containment+;
	return { <e, ch> | <m, ch> <- modified, e <- transContain[m], fun(e) };
}

private set[ModifiedEntity] transitiveEntities(M3 oldAPI, set[ModifiedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isAPIEntity);

private set[ModifiedEntity] transitiveMethods(M3 oldAPI, set[ModifiedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isMethod);

private set[ModifiedEntity] transitiveConstructors(M3 oldAPI, set[ModifiedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isConstructor);

private set[ModifiedEntity] transitiveFields(M3 oldAPI, set[ModifiedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isField);

private set[ModifiedEntity] transitiveSubtypes(M3 oldAPI, set[ModifiedEntity] modified) {
	rel[loc, loc] transExtends = oldAPI.extends+;
	return { <e, ch> | <m, ch> <- modified, e <- transExtends[m], isType(e) };
}

private set[Detection] detectionsAllUses(M3 client, set[ModifiedEntity] modified)
	= detections(client, modified, methodInvocation())
	+ detections(client, modified, fieldAccess())
	+ detections(client, modified, extends())
	+ detections(client, modified, implements())
	+ detections(client, modified, APIUse::annotation())
	+ detections(client, modified, typeDependency())
	+ detections(client, modified, methodOverride())
	;

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldLessAccessible()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[APIUse] apiUses = { fieldAccess() };
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(modif, delta);
		str field = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		
		set[loc] symbFields = subtypesFieldSymbolic(parent, field, client) 
			+ subtypesFieldSymbolic(parent, field, oldAPI)
			+ clientSubtypesFieldSymbolic(parent, field, oldAPI, client) + modif;
		
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbFields) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
			!(fromPublicToProtected(access.old, access.new) && hasProtectedAccess(client, oldAPI, elem, modif)), // Public to protected
			!(toPackageProtected(access.new) && samePackage(elem, modif)) }; // To package-private same package
	}
	return detects;
}
	
set[Detection] detectionsOld(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldLessAccessible()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
	
		// Let's get the old and new modifiers
		if (/apiField:field(modif,_,_,_,_) := delta, /modifier(modified(old, new)) := apiField) {
			set[loc] affected = domain(rangeR(client.fieldAccess, {modif}));
			
			// Include client affected elements that are subtypes of the 
			// modified field parent class, and where modifiers went from
			// public to protected
			detects += { detection(elem, modif, fieldAccess(), change) | elem <- affected,
				!(fromPublicToProtected(old, new) && hasProtectedAccess(client, oldAPI, elem, modif))};
		}
	}
	return detects;
}

private bool toPackageProtected(Modifier new) 
	= new == org::maracas::delta::JApiCmp::\packageProtected();
	
private bool fromPublicToProtected(Modifier old, Modifier new) 
	= old == org::maracas::delta::JApiCmp::\public() 
	&& new == org::maracas::delta::JApiCmp::\protected();
	
private bool hasProtectedAccess(M3 client, M3 oldAPI, loc elemClient, loc elemAPI) {
	loc apiParent = parentType(oldAPI, elemAPI);
	loc clientParent = parentType(client, elemClient);
	return (isKnown(clientParent) && isKnown(apiParent) && <clientParent, apiParent> in client.extends+);
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNoLongerStatic()) 
	= fieldDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowFinal()) 
	= symbFieldDetections(client, oldAPI, delta, ch, { fieldAccess() }); 
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowStatic()) 
	= symbFieldDetections(client, oldAPI, delta, ch, { fieldAccess() });

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldRemoved()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch); 
	return symbFieldDetections(client, oldAPI, modified, { fieldAccess() }) 
	+ detections(client, oldAPI, modified, fieldRemovedInSuperclass()); // Pertaining fieldRemovedInSuperclass
}

set[Detection] detections(M3 client, M3 oldAPI, set[ModifiedEntity] modified, ch:CompatibilityChange::fieldRemovedInSuperclass()) {
	CompatibilityChange change = fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false);
	return detectionsFieldRemovedInSuperclass(client, oldAPI, client.fieldAccess, modified, change, fieldAccess());
}
	
set[Detection] detectionsFieldRemovedInSuperclass(M3 client, M3 oldAPI, rel[loc, loc] m3Relation, set[ModifiedEntity] modified, CompatibilityChange ch, APIUse apiUse) {
	set[Detection] detects = {};
	
	for (<modif, _> <- modified) {
		str fieldName = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		
		// Get modif subtypes and symbolic fields/methods
		set[loc] symbFields = subtypesFieldSymbolic(parent, fieldName, oldAPI) 
			+ clientSubtypesFieldSymbolic(parent, fieldName, oldAPI, client);
		// Get affected client members
		set[loc] affected = domain(rangeR(client.fieldAccess, symbFields));
		detects += { detection(elem, modif, apiUse, ch) | elem <- affected };
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldStaticAndOverridesStatic()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		// TODO: check cases where the field is not declared in the subtype
		loc parent = parentType(newAPI, modif);
		str fieldName = memberName(modif);
		
		// Get all subtypes of the modified type
		rel[loc, loc] transExtends = newAPI.extends+;
		set[loc] subtypes = domain(rangeR(transExtends, {parent}));
		
		// Compute locations of the affected field (cf. javac encoding)
		set[loc] fields = { |java+field:///| + "<s.path>/<fieldName>" | s <- subtypes } + modif;
		rel[loc, loc] invFieldAccess = invert(client.fieldAccess);
		detects += { detection(elem, modif, fieldAccess(), change) 
			| f <- fields, elem <- invFieldAccess[f] };
	}
	
	return detects;
}

// TODO: check immediate parent only?
private set[loc] overridenStaticFields(M3 newAPI, loc field) {
	rel[loc, loc] transExtends = newAPI.extends+;
	loc parent = parentType(field);
	set[loc] supers = transExtends[parent];
	set[loc] fields = { *fields(m3Client.containment[s]) | s <- supers };
	return { f | f <- fields, sameFieldName(field, f) };
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldTypeChanged()) 
	= symbFieldDetections(client, oldAPI, delta, ch, { fieldAccess() });
	
private set[Detection] fieldDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, fieldAccess());
}

private set[Detection] symbFieldDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change, set[APIUse] apiUses) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return symbFieldDetections(client, oldAPI, modified, apiUses);
}

private set[Detection] symbFieldDetections(M3 client, M3 oldAPI, set[ModifiedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str fieldName = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbFields = subtypesFieldSymbolic(parent, fieldName, client) 
			+ clientSubtypesFieldSymbolic(parent, fieldName, oldAPI, client) + modif;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbFields) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

private set[loc] subtypesWithoutShadowing(loc typ, str elemName, M3 m, loc (loc, str) funSymbRef) {
	set[loc] subtypes = domain(rangeR(m.extends, { typ })) + domain(rangeR(m.implements, { typ }));
	return { *(subtypesWithoutShadowing(s, elemName, m, funSymbRef) + s) 
		| s <- subtypes, m.declarations[funSymbRef(s, elemName)] == {} };
}

set[loc] subtypesWithoutFieldShadowing(loc typ, str signature, M3 m)
	= subtypesWithoutShadowing(typ, signature, m, fieldSymbolicRef);

set[loc] subtypesWithoutMethShadowing(loc typ, str signature, M3 m)
	= subtypesWithoutShadowing(typ, signature, m, methodSymbolicRef);
	
private set[loc] clientSubtypesWithoutShadowing(loc typ, str elemName, M3 api, M3 client, loc (loc, str) funSymbRef) {
	set[loc] apiSubtypes = subtypesWithoutShadowing(typ, elemName, api, funSymbRef);
	return { subtypesWithoutShadowing(s, elemName, client, funSymbRef) | s <- apiSubtypes };
}

set[loc] clientSubtypesWithoutFieldShadowing(loc typ, str signature, M3 api, M3 client) 
	= clientSubtypesWithoutShadowing(typ, signature, api, client, fieldSymbolicRef);
	
set[loc] clientSubtypesWithoutMethShadowing(loc typ, str signature, M3 api, M3 client) 
	= clientSubtypesWithoutShadowing(typ, signature, api, client, methodSymbolicRef);

private set[loc] subtypesElemSymbolic(loc typ, str elemName, M3 m, loc (loc, str) funSymbRef) {
	set[loc] subtypes = subtypesWithoutShadowing(typ, elemName, m, funSymbRef);
	return { funSymbRef(s, elemName) | s <- subtypes};
}

set[loc] subtypesFieldSymbolic(loc typ, str fieldName, M3 m)
	= subtypesElemSymbolic(typ, fieldName, m, fieldSymbolicRef);

set[loc] subtypesMethodSymbolic(loc typ, str signature, M3 m)
	= subtypesElemSymbolic(typ, signature, m, methodSymbolicRef);
	
private set[loc] clientSubtypesElemSymbolic(loc typ, str elemName, M3 api, M3 client, loc (loc, str) funSymbRef) {
	set[loc] apiSubtypes = subtypesWithoutShadowing(typ, elemName, api, funSymbRef);
	set[loc] refs = {};
	
	for (s <- apiSubtypes) {
		set[loc] clientSubtypes = subtypesWithoutShadowing(s, elemName, client, funSymbRef);
		refs += { funSymbRef(c, elemName) | c <- clientSubtypes };
	}
	
	return refs;
}

set[loc] clientSubtypesFieldSymbolic(loc typ, str fieldName, M3 api, M3 client)
	= clientSubtypesElemSymbolic(typ, fieldName, api, client, fieldSymbolicRef);

set[loc] clientSubtypesMethodSymbolic(loc typ, str signature, M3 api, M3 client)
	= clientSubtypesElemSymbolic(typ, signature, api, client, methodSymbolicRef);
	
set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAbstractNowDefault()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return detections(client, modified, methodOverride()) 
		+ detectionsMethodNowDefault(client, oldAPI, newAPI, modified);
}

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAbstractAddedToClass()) 
	= detectionsMethodAbstractAdded(newAPI, client.extends, delta, ch, extends());
	
set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAddedToInterface()) 
	= detectionsMethodAbstractAdded(newAPI, client.implements, delta, ch, implements());

private set[Detection] detectionsMethodAbstractAdded(M3 newAPI, rel[loc, loc] m3ClientRel, list[APIEntity] delta, CompatibilityChange ch, APIUse apiUse) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		// Identify API interface
		loc parent = parentType(newAPI, modif);
		// Chack affected classes
		set[loc] affected = domain(rangeR(m3ClientRel, {parent}));
		detects += { detection(elem, modif, apiUse, change) | elem <- affected };
	}
	
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodLessAccessible())
	= methodLessAccDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNewDefault()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return detectionsMethodNowDefault(client, oldAPI, newAPI, modified);
}

private set[Detection] detectionsMethodNowDefault(M3 client, M3 oldAPI, M3 newAPI, set[ModifiedEntity] modified) {
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		// Identify API interface
		loc parent = parentType(newAPI, modif);

		if (isKnown(parent)) {
			// Check client implements 
			set[loc] affectedClasses = domain(rangeR(client.implements, {parent}));
			
			// Consider the affected class if it has other implemented interfaces
			for (elem <- affectedClasses, size(client.implements[elem]) > 1 ) {
				//Get method declarations
				set[loc] methods = methodDeclarations(client, elem);
				
				// There is a potential issue if one of the invoked methods has 
				// the same signature
				if (m <- methods, mi <- client.methodInvocation[m], sameMethodSignature(modif, mi)) {
					// TODO: change apiUse?
					detects += detection(elem, modif, methodInvocation(), change);
					continue;
				}
			}
		}
		
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAbstractAddedInSuperclass())
	= extendsDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNoLongerStatic()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return detections(client, modified, methodInvocation());
}

private set[Detection] symbTypeDetectionsWithParent(M3 client, M3 oldAPI, set[ModifiedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] subtypes = subtypesWithoutMethShadowing(parent, signature, client) 
			+ subtypesWithoutMethShadowing(parent, signature, oldAPI)
			+ clientSubtypesWithoutMethShadowing(parent, signature, oldAPI, client)
			+ parent;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, subtypes) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowAbstract()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return symbTypeDetectionsWithParent(client, oldAPI, modified, { extends(), implements() }) 
		+ symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation() }) ;
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowFinal()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return symbMethodDetections(client, oldAPI, modified, { methodOverride() });
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowStatic()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation(), methodOverride() });
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowThrowsCheckedException())
	= methodAllDetections(client, oldAPI, delta, ch);
		
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodRemoved()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, client) + modif;
		rel[loc, APIUse] affected = domain(rangeR(client.methodInvocation, symbMeths)) * { methodInvocation() }
			+ domain(rangeR(client.methodOverrides, symbMeths)) * { methodOverride() };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected};
	}
	
	return detects + detections(client, oldAPI, modified, methodRemovedInSuperclass()); // Pertaining methodRemovedInSuperclass
}

set[Detection] detections(M3 client, M3 oldAPI, set[ModifiedEntity] modified, CompatibilityChange::methodRemovedInSuperclass()) {
	CompatibilityChange change = methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false);
	return detectionsMethodRemovedInSuperclass(client, oldAPI, modified, change);
}

set[Detection] detectionsMethodRemovedInSuperclass(M3 client, M3 oldAPI, set[ModifiedEntity] modified, CompatibilityChange ch) {
	set[Detection] detects = {};
	
	for (<modif, _> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		
		// Get modif subtypes and symbolic methods
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, oldAPI)
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client);
		// Get affected client members
		rel[loc, APIUse] affected = domain(rangeR(client.methodInvocation, symbMeths)) * { methodInvocation() }
			+ domain(rangeR(client.methodOverrides, symbMeths)) * { methodOverride() };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	return detects;
}

set[loc] subtypesMethodReference(loc typ, str memName, M3 m) {
	rel[loc, loc] invExtends = invert(m.extends);
	set[loc] subtypes = invExtends[typ];
	loc meth = methodSymbolicRef(typ, memName);
	return { *(subtypesMethodReference(s, memName, m) + methodSymbolicRef(s, memName)) | s <- subtypes, m.declarations[methodSymbolicRef(s, memName)] == {}};
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodReturnTypeChanged()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation(), methodOverride() });
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::constructorLessAccessible())
	= methodLessAccDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::constructorRemoved()) 
	= methodInvDetections(client, oldAPI, delta, ch);

private set[Detection] methodAllDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, methodOverride())
		+ detections(client, modified, methodInvocation());
}

private set[Detection] methodInvDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, methodInvocation());
}

private set[Detection] methodOverrDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, methodOverride());
}

private set[Detection] methodLessAccDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[APIUse] apiUses = { methodInvocation(), methodOverride() };
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(modif, delta);
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, client) 
			+ subtypesMethodSymbolic(parent, signature, oldAPI)
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client) + modif;
			
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbMeths) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
			!(fromPublicToProtected(access.old, access.new) && hasProtectedAccess(client, oldAPI, elem, modif)), // Public to protected
			!(toPackageProtected(access.new) && samePackage(elem, modif)) }; // To package-private same package
	}
	return detects;
}

private tuple[Modifier, Modifier] getAccessModifiers(loc id, list[APIEntity] delta) {
	set[Modifier] accessModifs = { 
		org::maracas::delta::JApiCmp::\public(), 
		org::maracas::delta::JApiCmp::\protected(), 
		org::maracas::delta::JApiCmp::\packageProtected(), 
		org::maracas::delta::JApiCmp::\private() };
		
	if (/method(id,_,elems,_,_) := delta 
		|| /constructor(id,elems,_,_) := delta
		|| /field(id,_,elems,_,_) := delta
		|| /class(id,_,elems,_,_) := delta) {
		for (e <- elems, /modifier(modified(old, new)) := e, old in accessModifs) {
			return <old, new>;
		}
	}
	throw "There is no reference to <id> in the delta model.";
}

private set[Detection] symbMethodDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change, set[APIUse] apiUses) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return symbMethodDetections(client, oldAPI, modified, apiUses);
}

private set[Detection] symbMethodDetectionsWithParent(M3 client, M3 oldAPI, set[ModifiedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, oldAPI) 
			+ subtypesMethodSymbolic(parent, signature, client) 
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client) + modif;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbMeths) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

private set[Detection] symbMethodDetections(M3 client, M3 oldAPI, set[ModifiedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, oldAPI) 
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client) + modif;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbMeths) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

private rel[loc, APIUse] affectedEntities(M3 m, APIUse apiUse, set[loc] modified) {
	set[loc] affected = {};
	switch (apiUse) {
	case APIUse::annotation(): affected = domain(rangeR(m.annotations, modified));
	case extends(): affected = domain(rangeR(m.extends, modified));
	case fieldAccess(): affected = domain(rangeR(m.fieldAccess, modified));
	case implements(): affected = domain(rangeR(m.implements, modified));
	case methodInvocation(): affected = domain(rangeR(m.methodInvocation, modified));
	case methodOverride(): affected = domain(rangeR(m.methodOverrides, modified));
	case typeDependency(): affected = domain(rangeR(m.typeDependency, modified));
	default: throw "Wrong APIUse for member type: <apiUse>";
	}
	
	return affected * { apiUse };
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classLessAccessible())
	= detectionsClassLessAccess(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNoLongerPublic())
	= detectionsClassLessAccess(client, oldAPI, delta, ch);


set[Detection] detectionsClassLessAccess(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[APIUse] apiUses = { typeDependency(), extends(), implements(), APIUse::annotation() };
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(modif, delta);
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, { modif }) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
			!(fromPublicToProtected(access.old, access.new) && hasProtectedAccess(client, oldAPI, elem, modif)), // Public to protected
			!(toPackageProtected(access.new) && samePackage(elem, modif)) }; // To package-private same package
	}
	return detects;
}

set[Detection] detectionsClassLessAccessOld(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
	
		// Let's get the old and new modifiers
		// TODO: consider only access modifiers
		if (/apiClass:class(modif,_,_,_,_) := delta, /modifier(modified(old, new)) := apiClass) {
			rel[loc, APIUse] affected = domain(rangeR(client.typeDependency, {modif})) * { typeDependency() }
				+ domain(rangeR(client.extends, {modif})) * { extends() }
				+ domain(rangeR(client.implements, {modif})) * { implements() }
				+ domain(rangeR(client.annotations, {modif})) * { APIUse::annotation() };
			
			// Include client affected elements that are subtypes of the 
			// modified field parent class, and where modifiers went from
			// public to protected
			detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
				!(fromPublicToProtected(old, new) && hasProtectedAccess(client, oldAPI, elem, modif))};
		}
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNowAbstract()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[ModifiedEntity] transModified = transitiveConstructors(oldAPI, modified);
	return detections(client, transModified, methodInvocation());
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNowCheckedException()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[ModifiedEntity] transModified = transitiveSubtypes(oldAPI, modified) + modified;
	return detections(client, transModified, typeDependency())
		+ detections(client, transModified, extends());
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNowFinal()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[ModifiedEntity] transModified = transitiveMethods(oldAPI, modified);
	return detections(client, modified, extends()) 
		+ symbMethodDetections(client, oldAPI, transModified, { methodOverride() });
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classRemoved())
	= classAllDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classTypeChanged()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[ModifiedEntity] modifExtends = {};
	set[ModifiedEntity] modifImplements = {};
	set[ModifiedEntity] modifTypeDep = {};
	set[ModifiedEntity] modifAnnotation = {};
	
	for (<modif, change> <- modified) {
		APIEntity entity = entityFromLoc(modif, delta);
		tuple[ClassType, ClassType] types = classModifiedType(entity);
		
		switch(types) {
		case <class(), _> :
			modifExtends += <modif, change>;
		case <interface(), _> : {
			modifExtends += <modif, change>;
			modifImplements += <modif, change>;
		}
		case <annotation(), _> :
			modifAnnotation += <modif, change>;
		case <_, annotation()> :
			modifTypeDep += <modif, change>;
		default: ;
		}
	}
	
	return detections(client, modifExtends, extends())
		+ detections(client, modifImplements, implements())
		+ detections(client, modifTypeDep, typeDependency())
		+ detections(client, modifAnnotation, annotation());
}

private set[Detection] classAllDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, extends())
		+ detections(client, modified, implements())
		+ detections(client, modified, typeDependency())
		+ detections(client, modified, APIUse::annotation());
}

private set[Detection] extendsDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, extends());
}

private set[Detection] implementsDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, implements());
}

private set[Detection] typeDependencyDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, typeDependency());
}

	
@doc {
	Identifies the API uses that affect client code given an APIUse. 
	It relates modified API entities owning compatibility changes to 
	the client declaration that uses it according to the selected 
	APIUse (e.g. method invocation, field access).
	
	@param m3Relation: M3 relation of the client project (e.g. 
	       methodInvocation)
	@param modified: relation mapping modified API entities to the 
	       type of experienced change
	@param apiUse: type of API use (e.g. methodInvocation())
	@return set of Detections (API usages affected by API evolution)
}
private set[Detection] detections(M3 client, set[ModifiedEntity] modified, APIUse apiUse) 
	= { detection(elem, modif, apiUse, ch) | <modif, ch> <- modified, 
		<elem, apiUse> <- affectedEntities(client, apiUse, { modif }) };
		
private set[Detection] detections(M3 client, set[ModifiedEntity] modified, set[APIUse] apiUses) 
	= { *detections(client, modified, apiUse) | apiUse <- apiUses };