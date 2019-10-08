module org::maracas::delta::JApiCmpDetectorNew

import lang::java::m3::AST;
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

data Evolution = evolution(M3 client, M3 apiOld, M3 apiNew, list[APIEntity] delta);

alias TransChangedEntity = tuple[loc main, loc trans];

alias RippleEffect = tuple[loc changed, loc affected];
	
	
//----------------------------------------------
// Functions
//----------------------------------------------


// TODO: Move to other module
private set[loc] getSubtypesWithoutShadowing(loc class, str elemName, M3 m, loc (loc, str) createSymbRef) {
	set[loc] subtypes = domain(rangeR(m.extends, { class })) + domain(rangeR(m.implements, { class }));
	
	return { *(getSubtypesWithoutShadowing(s, elemName, m, createSymbRef) + s) 
		| s <- subtypes, m.declarations[createSymbRef(s, elemName)] == {} }
		+ class;
}

set[loc] getMethSubsWithoutShadowing(loc class, str signature, M3 m)
	= getSubtypesWithoutShadowing(class, signature, m, createMethodSymbolicRef);
	
private set[loc] createHierarchySymbRefs(loc class, str elemName, M3 api, M3 client, loc (loc, str) createSymbRef) {
	set[loc] apiSubtypes = getSubtypesWithoutShadowing(class, elemName, api, createSymbRef);
	set[loc] clientSubtypes = { *getSubtypesWithoutShadowing(s, elemName, client, createSymbRef) | s <- apiSubtypes };
	return { createSymbRef(c, elemName) | c <- apiSubtypes + clientSubtypes };
}

set[loc] createHierarchyFieldSymbRefs(loc class, str fieldName, M3 api, M3 client)
	= createHierarchySymbRefs(class, fieldName, api, client, createFieldSymbolicRef);

set[loc] createHierarchyMethSymbRefs(loc class, str signature, M3 api, M3 client)
	= createHierarchySymbRefs(class, signature, api, client, createMethodSymbolicRef);
	
	
	
	
	
set[Detection] detections(M3 client, M3 apiOld, M3 apiNew, list[APIEntity] delta) {
	Evolution evol = evolution(client, apiOld, apiNew, delta);
	return computeDetections(evol, fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
		+ computeDetections(evol, fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
		+ computeDetections(evol, fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
		+ computeDetections(evol, fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
		+ computeDetections(evol, fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
		+ computeDetections(evol, fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
		;
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldLessAccessible()) 
	= computeFieldSymbDetections(evol, ch, predicateFieldLessAccessible);

private bool predicateFieldLessAccessible(RippleEffect effect, Evolution evol) {
	tuple[Modifier old, Modifier new] access = getAccessModifiers(effect.changed, evol.delta);
	return !(isChangedFromPublicToProtected(access.old, access.new) && hasProtectedAccess(effect, evol)) // Public to protected
		&& !(isPackageProtected(access.new) && samePackage(effect.affected, effect.changed)); // To package-private same package
}

private bool hasProtectedAccess(RippleEffect effect, Evolution evol) {
	loc apiParent = parentType(evol.apiOld, effect.changed);
	loc clientParent = parentType(evol.client, effect.affected);
	return (isKnown(clientParent) && isKnown(apiParent) && <clientParent, apiParent> in evol.client.extends+);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNoLongerStatic()) 
	= computeDetections(evol, ch, { fieldAccess() });

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNowFinal()) 
	= computeFieldSymbDetections(evol, ch); 

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNowStatic()) 
	= computeFieldSymbDetections(evol, ch);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldRemoved()) 
	= computeFieldSymbDetections(evol, ch);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldTypeChanged()) 
	= computeFieldSymbDetections(evol, ch);
	
set[Detection] computeFieldSymbDetections(Evolution evol, CompatibilityChange change)
	= computeFieldSymbDetections(evol, change, bool (RippleEffect effect, Evolution evol) { return true; });
	
set[Detection] computeFieldSymbDetections(Evolution evol, CompatibilityChange change, bool (RippleEffect, Evolution) predicate) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	set[APIUse] apiUses = { fieldAccess() };
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str field = memberName(e);
		loc parent = parentType(evol.apiOld, e);
		set[loc] symbFields = createHierarchyFieldSymbRefs(parent, field, evol.apiOld, evol.client);
		entities += { e } * symbFields;
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate);
}

private rel[loc, APIUse] getAffectedEntities(M3 client, APIUse apiUse, set[loc] entities) {
	set[loc] affected = {};
	
	switch (apiUse) {
	case APIUse::annotation(): affected = domain(rangeR(client.annotations, entities));
	case extends(): affected = domain(rangeR(client.extends, entities));
	case fieldAccess(): affected = domain(rangeR(client.fieldAccess, entities));
	case implements(): affected = domain(rangeR(client.implements, entities));
	case methodInvocation(): affected = domain(rangeR(client.methodInvocation, entities));
	case methodOverride(): affected = domain(rangeR(client.methodOverrides, entities));
	case typeDependency(): affected = domain(rangeR(client.typeDependency, entities));
	default: throw "Wrong APIUse for member type: <apiUse>";
	}
	
	return affected * { apiUse };
}

private set[Detection] computeDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses) {
	set[loc] entities = getChangedEntities(evol.delta, change);
	rel[loc, APIUse] affected = { *getAffectedEntities(evol.client, apiUse, entities) | apiUse <- apiUses };
	return { detection(elem, used, apiUse, change) | <elem, apiUse> <- affected, used <- entities };
}

private set[Detection] computeDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses) 
	= computeDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

private set[Detection] computeDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[loc] changed = domain(entities);
	set[Detection] detects = {};
	
	for (used <- changed) {
		set[loc] transChanged = entities[used] + used;
		rel[loc, APIUse] affected = { *getAffectedEntities(evol.client, apiUse, transChanged) | apiUse <- apiUses };
		detects += { detection(elem, used, apiUse, change) | <elem, apiUse> <- affected, predicate(<used, elem>, evol) };
	}
	
	return detects;
}