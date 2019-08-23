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
	| methodOverrides()
	| fieldAcces() 
	| extends()
	| implements()
	| annotation()
	| typeDependency()
	;


//----------------------------------------------
// Functions
//----------------------------------------------

@memo
rel[loc, loc] invMethodInvocation(M3 m) = invert(m.methodInvocation);

@doc {
	Identifies the API uses that affect client code. It relates 
	modified API entities owning compatibility changes to the client
	declaration that uses it.
	
	@param client: M3 model of the client project
	@param oldAPI: M3 model of the old API
	@param delta: list of modified APIEntities between two versions 
	       of the target API.
	@return set of Detections (API usages affected by API evolution)
}
set[Detection] simpleDetections(M3 client, M3 oldAPI, list[APIEntity] delta) {
 	rel[loc, CompatibilityChange] modified = modifiedEntities(delta);
 	return detectionsAllUses(client, modified);
 }
 
 private set[Detection] detectionsAllUses(M3 client, rel[loc, CompatibilityChange] modified)
	= detections(client, modified, methodInvocation())
	+ detections(client, modified, fieldAcces())
	+ detections(client, modified, extends())
	+ detections(client, modified, implements())
	+ detections(client, modified, annotation())
	+ detections(client, modified, typeDependency())
	+ detections(client, modified, methodOverrides());
 
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
private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, mi:methodInvocation())
	= detections(client.methodInvocation, modified, mi); 
	
private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, fa:APIUse::fieldAcces())
	= detections(client.fieldAccess, modified, fa);

private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, e:APIUse::extends())
	= detections(client.extends, modified, e);

private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, i:APIUse::implements())
	= detections(client.implements, modified, i);
		
private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, a:APIUse::annotation())
	= detections(client.annotations, modified, a);
	
private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, td:APIUse::typeDependency())
	= detections(client.typeDependency, modified, td);

private set[Detection] detections(M3 client, rel[loc, CompatibilityChange] modified, mo:APIUse::methodOverrides())
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

@doc {
	Returns a relation mapping API entities that have been
	modified to the type of compatibility change they experienced.
	It consdiers a list of API entities as input (a.k.a. API delta).
	
	@param delta: list of modified APIEntities between two versions 
	       of the target API.
	@return relation mapping modified API entities to compatibility
	        change types (e.g. renamedMethod())
}
rel[loc, CompatibilityChange] modifiedEntities(list[APIEntity] delta) 
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
rel[loc, CompatibilityChange] modifiedEntities(APIEntity entity) {
	rel[loc, CompatibilityChange] modified = {};
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

set[Detection] transitiveDetections(M3 client, M3 oldAPI, list[APIEntity] delta) {
 	return transitiveDetections(client, oldAPI, delta, annotationDeprecatedAdded())
 	+ simpleDetections(client, delta, classRemoved())
 	+ simpleDetections(client, delta, classNowAbstract())
 	+ subclassDetections(client, oldAPI, delta, classNowFinal())
 	+ transitiveDetections(client, oldAPI, delta, classNoLongerPublic())
 	//+ transitiveDetections(client, oldAPI, delta, classTypeChanged())
 	+ subclassDetections(client, oldAPI, delta, classNowCheckedException())
 	+ transitiveDetections(client, oldAPI, delta, classLessAccessible())
 	+ subclassDetections(client, oldAPI, delta, superclassRemoved())
 	
 	;
}

private default set[Detection] transitiveDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	rel[loc, CompatibilityChange] modified = modifiedEntitiesPerChange(delta, ch);
	rel[loc, CompatibilityChange] transModified = transModifiedEntitiesPerChange(oldAPI, delta, ch);
	return detectionsAllUses(client, modified) + detectionsAllUses(client, transModified);
}
	
private set[Detection] simpleDetections(M3 client, list[APIEntity] delta, CompatibilityChange change) {
	rel[loc, CompatibilityChange] modified = modifiedEntitiesPerChange(delta, change);
	return detectionsAllUses(client, modified);
}

private default set[Detection] subclassDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	rel[loc, CompatibilityChange] modified = modifiedEntitiesPerChange(delta, change);
	rel[loc, CompatibilityChange] subclassModified = subclassModifiedEntitiesPerChange(oldAPI, delta, change);
	return detectionsAllUses(client, modified) + detectionsAllUses(client, subclassModified);
}

rel[loc, CompatibilityChange] subclassModifiedEntitiesPerChange(M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	rel[loc, CompatibilityChange] modified = modifiedEntitiesPerChange(delta, change);
	rel[loc, loc] subclassContain = oldAPI.extends+;
	return { <e, change> | <m,_> <- modified, e <- subclassContain[m]};
}

rel[loc, CompatibilityChange] transModifiedEntitiesPerChange(M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	rel[loc, CompatibilityChange] modified = modifiedEntitiesPerChange(delta, change);
	rel[loc, loc] transContain = oldAPI.containment+;
	return { <e, change> | <m,_> <- modified, e <- transContain[m], isType(e) || isMethod(e) || isField(e) };
}

rel[loc, CompatibilityChange] modifiedEntitiesPerChange(list[APIEntity] delta, CompatibilityChange change) 
	= { *modifiedEntitiesPerChange(entity, change) | entity <- delta };
	
rel[loc, CompatibilityChange] modifiedEntitiesPerChange(APIEntity entity, CompatibilityChange change) {
	rel[loc, CompatibilityChange] modified = {};
	visit (entity) {
	case /c:class(id,_,_,chs,_): 
		modified = addModifiedElement(id, modified, change, chs);
	case /i:interface(id,chs,_):
		modified = addModifiedElement(id, modified, change, chs);
	case /f:field(id,_,_,chs,_): 
		modified = addModifiedElement(id, modified, change, chs);
	case /m:method(id,_,_,chs,_): 
		modified = addModifiedElement(id, modified, change, chs);
	case /c:constructor(id,_,chs,_): 
		modified = addModifiedElement(id, modified, change, chs);
	}
	return modified;
}

private rel[loc, CompatibilityChange] addModifiedElement(loc element, rel[loc, CompatibilityChange] modElements, CompatibilityChange change, list[CompatibilityChange] changes)
	= (/change := changes) ? modElements + <element, change> : modElements;

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
private rel[loc, CompatibilityChange] addModifiedElement(loc element, rel[loc, CompatibilityChange] modElements, list[CompatibilityChange] changes) {
	rel[loc, CompatibilityChange] newElements = { <element, c> | c <- changes };
	return modElements + newElements;
}