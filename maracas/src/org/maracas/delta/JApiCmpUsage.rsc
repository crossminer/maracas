module org::maracas::delta::JApiCmpUsage

import lang::java::m3::Core;
import Relation;

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::m3::Core;
import org::maracas::m3::Containment;
import org::maracas::m3::Inheritance;


set[loc] getUsedBreakingEntities(set[Detection] detects) 
	= { d.src | Detection d <- detects };

set[loc] getUsedBreakingEntities(set[Detection] detects, CompatibilityChange ch) 
	= { d.src | Detection d <- detects, d.change == ch };

map[CompatibilityChange, set[loc]] getUsedBreakingEntitiesMap(set[Detection] detects) {
	map[CompatibilityChange, set[loc]] breaking = ();
	for (Detection d <- detects) {
		CompatibilityChange change = d.change;
		breaking += ( change : (change in breaking) ? breaking[change] + d.src : { d.src });
	}
	return breaking;
}

set[loc] getUsedNonBreakingEntities(Evolution evol, set[Detection] detects, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[loc] breaking = getUsedBreakingEntities(detects, ch);
	set[loc] unused = getUnusedChangedEntities(evol, ch);
	return getUsedNonBreakingEntities(entities, breaking, unused);
}

map[CompatibilityChange, set[loc]] getUsedNonBreakingEntitiesMap(Evolution evol, set[Detection] detects) {
	map[CompatibilityChange, set[loc]] entities = getChangedEntitiesMap(evol.delta);
	map[CompatibilityChange, set[loc]] breaking = getUsedBreakingEntitiesMap(detects);
	map[CompatibilityChange, set[loc]] unused = getUnusedChangedEntitiesMap(evol);
	map[CompatibilityChange, set[loc]] nonbreaking = ();
	
	for (CompatibilityChange c <- entities) {
		set[loc] ent = entities[c];
		set[loc] entitiesBreaking = (c in breaking) ? breaking[c] : {};
		set[loc] entitiesUnused = (c in unused) ? unused[c] : {};
		set[loc] entitiesNonbreaking = getUsedNonBreakingEntities(entities[c], entitiesBreaking, entitiesUnused);
		nonbreaking += (c : entitiesNonbreaking);
	}
	
	return nonbreaking;
}

private set[loc] getUsedNonBreakingEntities(set[loc] entities, set[loc] breaking, set[loc] unused) 
	= entities - breaking - unused;


set[loc] getUnusedChangedEntities(Evolution evol) {
	set[loc] entities = getChangedEntitiesLoc(evol.delta);	
	return getUnusedChangedEntities(evol, entities);
}

set[loc] getUnusedChangedEntities(Evolution evol, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(evol.delta, ch);	
	return getUnusedChangedEntities(evol, entities);
}

map[CompatibilityChange, set[loc]] getUnusedChangedEntitiesMap(Evolution evol) {
	map[CompatibilityChange, set[loc]] changed = getChangedEntitiesMap(evol.delta);
	map[CompatibilityChange, set[loc]] unused = ();
	
	for (CompatibilityChange c <- changed) {
		set[loc] entities = changed[c];
		set[loc] entitiesUnused = getUnusedChangedEntities(evol, entities);
		unused += (c : entitiesUnused);	
	}
	return unused;
}

private set[loc] getUnusedChangedEntities(Evolution evol, set[loc] entities) {
	set[TransChangedEntity] transEntities = getTransEntities(entities, evol);
	set[loc] unused = {};
	
	for (loc e <- entities) {
		if (isUsed(e, evol)) {
			continue;
		}
		
		bool used = false;
		for (loc c <- transEntities[e]) {
			if (isUsed(c, evol)) {
				used = true;
				break;
			}
		}
		
		if (used) {
			continue;
		}
		unused += e;
	}
	return unused;
}

bool isUsed(loc elem, Evolution evol) {
	M3 m = evol.client;
	
	return m.invertedAnnotations[elem] != {}
	|| m.invertedExtends[elem] != {}
	|| m.invertedFieldAccess[elem] != {}
	|| m.invertedImplements[elem] != {}
	|| m.invertedMethodInvocation[elem] != {}
	|| m.invertedMethodOverrides[elem] != {}
	|| m.invertedTypeDependency[elem] != {}
	;
}
	
private set[TransChangedEntity] getTransEntities(set[loc] entities, Evolution evol)
	= { *getTransEntities(e, evol) | loc e <- entities };
	
private set[TransChangedEntity] getTransEntities(loc elem, Evolution evol)
	= isType(elem) ? getTransTypeEntities(elem, evol)
	: isMethod(elem) ? getTransMethEntities(elem, evol)
	: isField(elem) ? getTransFieldEntities(elem, evol)
	: {}
	+ <elem, elem> // Add itself (in case it is not included in previous tuples)
	;

private set[TransChangedEntity] getTransTypeEntities(loc elem, Evolution evol) {	
	set[TransChangedEntity] transFields = getContainedFields(evol.apiOld, elem);
	set[TransChangedEntity] transMeths = getContainedMethods(evol.apiOld, elem);
	set[TransChangedEntity] subtypes = { elem } * getSubtypes(elem, evol.apiOld);
	return transFields + transMeths + subtypes;
}

private set[TransChangedEntity] getTransMethEntities(loc elem, Evolution evol) {
	str signature = methodSignature(elem);
	loc parent = parentType(evol.apiOld, elem);
	set[TransChangedEntity] symbMeths = { elem } * createHierarchySymbRefs(parent, elem.scheme, signature, evol.apiOld, evol.client, allowShadowing = false);
	return symbMeths;
}

private set[TransChangedEntity] getTransFieldEntities(loc elem, Evolution evol) {
	str field = memberName(elem);
	loc parent = parentType(evol.apiOld, elem);
	set[TransChangedEntity] symbFields = { elem } * createHierarchySymbRefs(parent, elem.scheme, field, evol.apiOld, evol.client, allowShadowing = false);
	return symbFields;
}