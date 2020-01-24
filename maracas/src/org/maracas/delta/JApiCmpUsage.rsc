module org::maracas::delta::JApiCmpUsage

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::m3::Core;
import org::maracas::m3::Containment;
import org::maracas::m3::Inheritance;


set[loc] getUsedBreakingEntities(set[Detection] detects) 
	= { e | detection(_, _, loc e, _, _) <- detects };

set[loc] getUsedBreakingEntities(set[Detection] detects, CompatibilityChange ch) 
	= { e | detection(_, _, loc e, _, CompatibilityChange c) <- detects, c == ch };

		
set[loc] getUsedNonBreakingEntities(Evolution evol, set[Detection] detects) {
	set[loc] entities = getChangedEntitiesLoc(evol.delta);
	set[loc] breaking = getUsedBreakingEntities(detects);
	return getUsedNonBreakingEntities(evol, entities, breaking);
}

set[loc] getUsedNonBreakingEntities(Evolution evol, set[Detection] detects, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[loc] breaking = getUsedBreakingEntities(detects, ch);
	return getUsedNonBreakingEntities(evol, entities, breaking);
}

private set[loc] getUsedNonBreakingEntities(Evolution evol, set[loc] entities, set[loc] breaking) {
	set[loc] nonBreaking = entities - breaking;
	return { e | loc e <- nonBreaking, isUsed(e, evol) };
}


set[loc] getUnusedChangedEntities(Evolution evol) {
	set[loc] entities = getChangedEntitiesLoc(evol.delta);	
	return getUnusedChangedEntities(evol, entities);
}

set[loc] getUnusedChangedEntities(Evolution evol, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(evol.delta, ch);	
	return getUnusedChangedEntities(evol, entities);
}

private set[loc] getUnusedChangedEntities(Evolution evol, set[loc] entities) {
	set[TransChangedEntity] transEntities = getTransEntities(entities, evol);
	set[loc] unused = {};
	
	for (loc e <- entities) {
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
	
	return invertRel(m.annotations)[elem] != {}
	|| invertRel(m.extends)[elem] != {}
	|| invertRel(m.fieldAccess)[elem] != {}
	|| invertRel(m.implements)[elem] != {}
	|| invertRel(m.methodInvocation)[elem] != {}
	|| invertRel(m.methodOverrides)[elem] != {}
	|| invertRel(m.typeDependency)[elem] != {}
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