module org::maracas::delta::JApiCmpDetector

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;
import Relation;
import Set;


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
private rel[loc, CompatibilityChange] addModifiedElement(loc element, set[ModifiedEntity] modElements, list[CompatibilityChange] changes)
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
 	+ detections(client, oldAPI, delta, classLessAccessible())
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
	rel[loc, CompatibilityChange] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	modified += transitiveEntities(oldAPI, modified);
	return detectionsAllUses(client, modified);
}

private rel[loc, CompatibilityChange] transitiveEntities(M3 oldAPI, rel[loc, CompatibilityChange] modified) {
	rel[loc, loc] transContain = oldAPI.containment+;
	return { <e, ch> | <m, ch> <- modified, e <- transContain[m], isAPIEntity(e) };
}

private rel[loc, CompatibilityChange] transitiveMethods(M3 oldAPI, rel[loc, CompatibilityChange] modified) {
	rel[loc, loc] transContain = oldAPI.containment+;
	return { <e, ch> | <m, ch> <- modified, e <- transContain[m], isMethod(e) };
}

private rel[loc, CompatibilityChange] transitiveConstructors(M3 oldAPI, rel[loc, CompatibilityChange] modified) {
	rel[loc, loc] transContain = oldAPI.containment+;
	return { <e, ch> | <m, ch> <- modified, e <- transContain[m], isConstructor(e) };
}

private rel[loc, CompatibilityChange] transitiveSubtypes(M3 oldAPI, rel[loc, CompatibilityChange] modified) {
	rel[loc, loc] transExtends = oldAPI.extends+;
	return { <e, ch> | <m, ch> <- modified, e <- transExtends[m], isType(e) };
}

private set[Detection] detectionsAllUses(M3 client, rel[loc, CompatibilityChange] modified)
	= detections(client, modified, methodInvocation())
	+ detections(client, modified, fieldAccess())
	+ detections(client, modified, extends())
	+ detections(client, modified, implements())
	+ detections(client, modified, annotation())
	+ detections(client, modified, typeDependency())
	+ detections(client, modified, methodOverride())
	;
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldLessAccessible()) {
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

private bool fromPublicToProtected(Modifier old, Modifier new) 
	= old == org::maracas::delta::JApiCmp::\public() 
		&& new == org::maracas::delta::JApiCmp::\protected();
	
private bool hasProtectedAccess(M3 client, M3 oldAPI, loc elemClient, loc elemAPI) {
	loc apiParent = parentType(oldAPI, elemAPI);
	loc clientParent = parentType(client, elemClient);
	return (isKnown(clientParent) && isKnown(apiParent) && <clientParent, apiParent> in client.extends);
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNoLongerStatic()) 
	= fieldDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowFinal()) 
	= fieldDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowStatic()) 
	= fieldDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldRemoved()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return detections(client, modified, fieldAccess())
		+ detections(client, oldAPI, modified, fieldRemovedInSuperclass()); // Pertaining fieldRemovedInSuperclass
} 

set[Detection] detections(M3 client, M3 oldAPI, set[ModifiedEntity] modified, ch:CompatibilityChange::fieldRemovedInSuperclass()) {
	CompatibilityChange change = fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false);
	return detectionsFieldRemovedInSuperclass(oldAPI, client.fieldAccess, modified, change, fieldAccess());
}
	
set[Detection] detectionsFieldRemovedInSuperclass(M3 oldAPI, rel[loc, loc] m3Relation, set[ModifiedEntity] modified, CompatibilityChange ch, APIUse apiUse) {
	rel[loc, loc] invM3Relation = invert(m3Relation);
	set[Detection] detects = {};
	
	for (<modif, _> <- modified) {
		str fieldName = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		
		// Get modif subtypes and symbolic fields/methods
		set[loc] symbMembers = subtypesFieldReference(parent, fieldName, oldAPI);
		// Get affected client members
		set[loc] affected = { *invM3Relation[f] | f <- symbMembers };
		detects += { detection(elem, modif, apiUse, ch) | elem <- affected };
	}
	return detects;
}

set[loc] subtypesFieldReference(loc typ, str memName, M3 m) {
	rel[loc, loc] invExtends = invert(m.extends);
	set[loc] subtypes = invExtends[typ];
	loc field = fieldSymbolicRef(typ, memName);
	return { *(subtypesFieldReference(s, memName, m) + fieldSymbolicRef(s, memName)) | s <- subtypes, m.declarations[fieldSymbolicRef(s, memName)] == {}};
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
	= fieldDetections(client, oldAPI, delta, ch);
	
private set[Detection] fieldDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, fieldAccess());
}
	
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
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNoLongerStatic())
	= methodInvDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowAbstract()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		// Identify API class
		loc parent = parentType(oldAPI, modif);
		
		if (isKnown(parent)) {
			// Check client extends
			set[loc] affectedClasses = domain(rangeR(client.extends, {parent}))
				+ domain(rangeR(client.implements, {parent}));
			
			// Check method override relation
			set[loc] overriden = domain(rangeR(client.methodOverrides, {modif}));
			set[loc] nonAffectedClasses = { parentType(client, mo) | mo <- overriden };
			affectedClasses = affectedClasses - nonAffectedClasses;
			
			// TODO: change apiUse?
			// Check that affected classes are not abstract
			detects += { detection(elem, modif, methodOverride(), change) | elem <- affectedClasses, isClass(elem), 
				org::maracas::delta::JApiCmp::abstract() notin client.modifiers };
		}
	}
	
	return detects + detections(client, modified, APIUse::methodInvocation());
}
 	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowFinal())
	= methodOverrDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowStatic())
	= methodAllDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowThrowsCheckedException())
	= methodAllDetections(client, oldAPI, delta, ch);
		
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodRemoved()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	return detections(client, modified, methodOverride())
		+ detections(client, modified, methodInvocation())
		+ detections(client, oldAPI, modified, methodRemovedInSuperclass()); // Pertaining methodRemovedInSuperclass
}

set[Detection] detections(M3 client, M3 oldAPI, set[ModifiedEntity] modified, CompatibilityChange::methodRemovedInSuperclass()) {
	CompatibilityChange change = methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false);
	// TODO: This is not optimal. Doing the same thing twice! Refactor.
	return detectionsMethodRemovedInSuperclass(oldAPI, client.methodInvocation, modified, change, methodInvocation())
		+ detectionsMethodRemovedInSuperclass(oldAPI, client.methodOverrides, modified, change, methodOverride());
}

set[Detection] detectionsMethodRemovedInSuperclass(M3 oldAPI, rel[loc, loc] m3Relation, set[ModifiedEntity] modified, CompatibilityChange ch, APIUse apiUse) {
	rel[loc, loc] invM3Relation = invert(m3Relation);
	set[Detection] detects = {};
	
	for (<modif, _> <- modified) {
		str methName = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		
		// Get modif subtypes and symbolic fields/methods
		set[loc] symbMembers = subtypesMethodReference(parent, methName, oldAPI);
		// Get affected client members
		set[loc] affected = { *invM3Relation[f] | f <- symbMembers };
		detects += { detection(elem, modif, apiUse, ch) | elem <- affected };
	}
	return detects;
}

set[loc] subtypesMethodReference(loc typ, str memName, M3 m) {
	rel[loc, loc] invExtends = invert(m.extends);
	set[loc] subtypes = invExtends[typ];
	loc meth = methodSymbolicRef(typ, memName);
	return { *(subtypesMethodReference(s, memName, m) + methodSymbolicRef(s, memName)) | s <- subtypes, m.declarations[methodSymbolicRef(s, memName)] == {}};
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodReturnTypeChanged())
	= methodAllDetections(client, oldAPI, delta, ch);

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
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
	
		// Let's get the old and new modifiers
		if (/apiMeth:method(modif,_,_,_,_) := delta || /apiMeth:constructor(modif,_,_,_) := delta,
			/modifier(modified(old, new)) := apiMeth) {
			rel[loc, APIUse] affected = domain(rangeR(client.methodInvocation, {modif})) * { methodInvocation() }
				+ domain(rangeR(client.methodOverrides, {modif})) * { methodOverride() };
			
			// Include client affected elements that are subtypes of the 
			// modified field parent class, and where modifiers went from
			// public to protected
			detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
				!(fromPublicToProtected(old, new) && hasProtectedAccess(client, oldAPI, elem, modif)) };
		}
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classLessAccessible())
	= detectionsClassLessAccess(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNoLongerPublic())
	= detectionsClassLessAccess(client, oldAPI, delta, ch);

set[Detection] detectionsClassLessAccess(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
	
		// Let's get the old and new modifiers
		// TODO: consider only access modifiers
		if (/apiClass:class(modif,_,_,_,_) := delta, /modifier(modified(old, new)) := apiClass) {
			rel[loc, APIUse] affected = domain(rangeR(client.typeDependency, {modif})) * { typeDependency() }
				+ domain(rangeR(client.extends, {modif})) * { extends() }
				+ domain(rangeR(client.implements, {modif})) * { implements() }
				+ domain(rangeR(client.annotations, {modif})) * { annotation() };
			
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
	set[ModifiedEntity] transModified = transitiveEntities(oldAPI, modified); // We only need methods
	return detections(client, modified, extends()) + detections(client, transModified, methodOverride());
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classRemoved())
	= classAllDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classTypeChanged()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	rel[loc, loc] invTypeDep = invert(client.typeDependency);
	rel[loc, loc] invExtends = invert(client.extends);
	rel[loc, loc] invImplements = invert(client.implements);
	rel[loc, loc] invAnnotations = invert(client.annotations);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		APIEntity entity = entityFromLoc(modif, delta);
		tuple[ClassType, ClassType] types = classModifiedType(entity);
		rel[loc, APIUse] affected = invTypeDep[modif] * {typeDependency()};
		
		switch(types) {
		case <class(), _> :
			affected += invExtends[modif] * {extends()};
		case <interface(), _> : {
			affected += invExtends[modif] * {extends()};
			affected += invImplements[modif] * {implements()};
		}
		case <annotation(), _> :
			affected += invAnnotations[modif] * {annotation()};
		default: ;
		}
		
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

private set[Detection] classAllDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, extends())
		+ detections(client, modified, implements())
		+ detections(client, modified, typeDependency())
		+ detections(client, modified, annotation());
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
	
	@param client: M3 model of the client project
	@param modified: relation mapping modified API entities to the 
	       type of experienced change
	@param apiUse: type of API use (e.g. methodInvocation())
	@return set of Detections (API usages affected by API evolution)
}
set[Detection] detections(M3 client, set[ModifiedEntity] modified, mi:APIUse::methodInvocation())
	= detections(client.methodInvocation, modified, mi); 
	
set[Detection] detections(M3 client, set[ModifiedEntity] modified, fa:APIUse::fieldAccess())
	= detections(client.fieldAccess, modified, fa);

set[Detection] detections(M3 client, set[ModifiedEntity] modified, e:APIUse::extends())
	= detections(client.extends, modified, e);

set[Detection] detections(M3 client, set[ModifiedEntity] modified, i:APIUse::implements())
	= detections(client.implements, modified, i);
		
set[Detection] detections(M3 client, set[ModifiedEntity] modified, a:APIUse::annotation())
	= detections(client.annotations, modified, a);
	
set[Detection] detections(M3 client, set[ModifiedEntity] modified, td:APIUse::typeDependency())
	= detections(client.typeDependency, modified, td);

set[Detection] detections(M3 client, set[ModifiedEntity] modified, mo:APIUse::methodOverride())
	= detections(client.methodOverrides, modified, mo);
	
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
private set[Detection] detections(rel[loc, loc] m3Relation, rel[loc, CompatibilityChange] modified, APIUse apiUse) {
	set[loc] modifiedLocs = domain(modified);
	rel[loc, loc] affected = rangeR(m3Relation, modifiedLocs);
	rel[loc, loc] invAffected = invert(affected);
	set[Detection] detects = {};
	
	for (modif <- modifiedLocs) {
		detects += { detection(elem, modif, apiUse, ch) | elem <- invAffected[modif], ch <- modified[modif] };
	}
	return detects;
}