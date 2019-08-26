module org::maracas::delta::JApiCmpDetector

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;
import Relation;


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
	| fieldAcces() 
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
private rel[loc, CompatibilityChange] addModifiedElement(loc element, set[ModifiedEntity] modElements, list[CompatibilityChange] changes) {
	rel[loc, CompatibilityChange] newElements = { <element, c> | c <- changes };
	return modElements + newElements;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta) 
 	= detections(client, oldAPI, delta, fieldNowFinal())
 	+ detections(client, oldAPI, delta, fieldNowStatic())
 	+ detections(client, oldAPI, delta, fieldRemoved())
 	+ detections(client, oldAPI, delta, fieldTypeChanged())
 	+ detections(client, oldAPI, delta, methodNowAbstract())
 	+ detections(client, oldAPI, delta, methodNowFinal())
 	+ detections(client, oldAPI, delta, methodNowStatic())
 	+ detections(client, oldAPI, delta, methodRemoved())
 	+ detections(client, oldAPI, delta, methodReturnTypeChanged())
 	+ detections(client, oldAPI, delta, constructorRemoved())
 	;

private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowFinal()) 
	= fieldDetections(client, oldAPI, delta, ch);
	
private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowStatic()) 
	= fieldDetections(client, oldAPI, delta, ch);

private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldRemoved())
	= fieldDetections(client, oldAPI, delta, ch);
	
private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldTypeChanged())
	= fieldDetections(client, oldAPI, delta, ch);
	
private set[Detection] fieldDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, APIUse::fieldAcces());
}

private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowAbstract()) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		// Identify API class
		loc parent = parentType(oldAPI, modif);
		
		if (parent != |unknown:///|) {
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

private loc parentType(M3 m, loc method) {
	rel[loc, loc] containers = rangeR(m.containment, {method});
	if (<p,_> <- containers, isType(p)) {
		return p;
	}
	return |unknwon:///|;
}
	
private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowFinal())
	= methodOverrDetections(client, oldAPI, delta, ch);
	
private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowStatic())
	= methodAllDetections(client, oldAPI, delta, ch);
	
private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodRemoved())
	= methodAllDetections(client, oldAPI, delta, ch);

private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodReturnTypeChanged())
	= methodAllDetections(client, oldAPI, delta, ch);
	
private set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::constructorRemoved()) 
	= methodInvDetections(client, oldAPI, delta, ch);

private set[Detection] methodAllDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, APIUse::methodOverride())
		+ detections(client, modified, APIUse::methodInvocation());
}

private set[Detection] methodInvDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, APIUse::methodInvocation());
}

private set[Detection] methodOverrDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ModifiedEntity] modified = filterModifiedEntities(modifiedEntities(delta), change);
	return detections(client, modified, APIUse::methodOverride());
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
private set[Detection] detections(M3 client, set[ModifiedEntity] modified, mi:APIUse::methodInvocation())
	= detections(client.methodInvocation, modified, mi); 
	
private set[Detection] detections(M3 client, set[ModifiedEntity] modified, fa:APIUse::fieldAcces())
	= detections(client.fieldAccess, modified, fa);

private set[Detection] detections(M3 client, set[ModifiedEntity] modified, e:APIUse::extends())
	= detections(client.extends, modified, e);

private set[Detection] detections(M3 client, set[ModifiedEntity] modified, i:APIUse::implements())
	= detections(client.implements, modified, i);
		
private set[Detection] detections(M3 client, set[ModifiedEntity] modified, a:APIUse::annotation())
	= detections(client.annotations, modified, a);
	
private set[Detection] detections(M3 client, set[ModifiedEntity] modified, td:APIUse::typeDependency())
	= detections(client.typeDependency, modified, td);

private set[Detection] detections(M3 client, set[ModifiedEntity] modified, mo:APIUse::methodOverride())
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