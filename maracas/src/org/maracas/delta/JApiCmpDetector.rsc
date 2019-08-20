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
 	set[Detection] detects = {};
 	rel[loc, CompatibilityChange] modified = modifiedEntities(delta);
 	
 	detects = simpleDetections(client, modified, methodInvocation())
 		+ simpleDetections(client, modified, fieldAcces())
 		+ simpleDetections(client, modified, extends())
 		+ simpleDetections(client, modified, implements())
 		+ simpleDetections(client, modified, annotation())
 		+ simpleDetections(client, modified, typeDependency());
 	
 	return detects;
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
private set[Detection] simpleDetections(M3 client, rel[loc, CompatibilityChange] modified, APIUse apiUse) {
	switch (apiUse) {
	case APIUse::methodInvocation() : return simpleDetections(client.methodInvocation, modified, methodInvocation());
	case APIUse::fieldAcces() : return simpleDetections(client.fieldAccess, modified, fieldAcces());
	case APIUse::extends() : return simpleDetections(client.extends, modified, extends());
	case APIUse::implements() : return simpleDetections(client.implements, modified, implements());
	case APIUse::annotation() : return simpleDetections(client.annotations, modified, annotation());
	case APIUse::typeDependency() : return simpleDetections(client.typeDependency, modified, typeDependency());
	default : throw "Unkown APIUse <apiUse>";
	}
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
private set[Detection] simpleDetections(rel[loc, loc] m3Relation, rel[loc, CompatibilityChange] modified, APIUse apiUse) {
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

private bool hasChange(list[CompatibilityChange] changes, CompatibilityChange change)
	= change in changes;