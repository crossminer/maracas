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

@memo
rel[loc, loc] invMethodInvocation(M3 m) = invert(m.methodInvocation);
 
set[Detection] simpleDetections(M3 client, M3 oldAPI, list[APIEntity] delta) {
 	set[Detection] detects = {};
 	rel[loc, CompatibilityChange] modified = modifiedEntities(delta);
 	
 	detects = simpleDetections(client, modified, methodInvocation());
 	detects = simpleDetections(client, modified, fieldAcces());
 	detects = simpleDetections(client, modified, extends());
 	detects = simpleDetections(client, modified, implements());
 	detects = simpleDetections(client, modified, annotation());
 	detects = simpleDetections(client, modified, typeDependency());
 	
 	return detects;
 }
 
private set[Detection] simpleDetections(M3 client, rel[loc, loc] modified, APIUse apiUse) {
	switch (apiUse) {
	case methodInvocation() : return simpleDetections(client.methodInvocation, modified);
	case fieldAcces() : return simpleDetections(client.fieldAccess, modified);
	case extends() : return simpleDetections(client.extends, modified);
	case implements() : return simpleDetections(client.implements, modified);
	case annotation() : return simpleDetections(client.annotation, modified);
	case typeDependency() : return simpleDetections(client.typeDependency, modified);
	default : throw "Unkown APIUse <apiUse>";
	}
}

private set[Detection] simpleDetections(rel[loc, loc] m3Relation, rel[loc, CompatibilityChange] modified) {
	set[loc] modifiedLocs = domain(modified);
	rel[loc, loc] affected = rangeR(m3Relation, modifiedLocs);
	rel[loc, loc] invAffected = invert(affected);
	set[Detection] detects = {};
	
	for (modif <- modifiedLocs) {
		detects += { detection(elem, modif, mi, ch) | elem <- invAffected[modif], ch <- modified[modif] };
	}
	return detects;
}

rel[loc, CompatibilityChange] modifiedEntities(list[APIEntity] delta) 
	= { *modifiedEntities(entity) | entity <- delta };

rel[loc, CompatibilityChange] modifiedEntities(APIEntity entity) {
	rel[loc, CompatibilityChange] modified = {};
	visit (entity) {
		case /c:class(id,_,_,chs,_): 
			modified = appendElement(id, modified, chs);
		case /i:interface(id,chs,_):
			modified = appendElement(id, modified, chs);
		case /f:field(id,_,_,chs,_): 
			modified = appendElement(id, modified, chs);
		case /m:method(id,_,_,chs,_): 
			modified = appendElement(id, modified, chs);
		case /c:constructor(id,_,chs,_): 
			modified = appendElement(id, modified, chs);
	}
	return modified;
}

private rel[loc, CompatibilityChange] appendElement(loc element, rel[loc, CompatibilityChange] elements, list[CompatibilityChange] changes) {
	rel[loc, CompatibilityChange] newElements = { <element, c> | c <- changes };
	return elements + newElements;
}

private bool hasChange(list[CompatibilityChange] changes, CompatibilityChange change)
	= change in changes;