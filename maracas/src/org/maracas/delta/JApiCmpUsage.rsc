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
	set[loc] unused = getUnusedChangedEntities(evol, detects, ch);
	return getUsedNonBreakingEntities(entities, breaking, unused);
}

map[CompatibilityChange, set[loc]] getUsedNonBreakingEntitiesMap(Evolution evol, set[Detection] detects) {
	map[CompatibilityChange, set[loc]] entities = getChangedEntitiesMap(evol.delta);
	map[CompatibilityChange, set[loc]] breaking = getUsedBreakingEntitiesMap(detects);
	map[CompatibilityChange, set[loc]] unused = getUnusedChangedEntitiesMap(evol, detects);
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


set[loc] getUnusedChangedEntities(Evolution evol, set[Detection] detects) {
	set[CompatibilityChange] changes =  getCompatibilityChanges(evol.delta);
	return { *getUnusedChangedEntities(evol, detects, c) | CompatibilityChange c <- changes };
}

map[CompatibilityChange, set[loc]] getUnusedChangedEntitiesMap(Evolution evol, set[Detection] detects) {
	map[CompatibilityChange, set[loc]] changed = getChangedEntitiesMap(evol.delta);
	map[CompatibilityChange, set[loc]] unused = ();
	
	for (CompatibilityChange c <- changed) {
		set[loc] entitiesUnused = getUnusedChangedEntities(evol, detects, c);
		unused += (c : entitiesUnused);	
	}
	return unused;
}

set[loc] getUnusedChangedEntities(Evolution evol, set[Detection] detects, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[TransChangedEntity] transEntities = getTransEntities(evol, ch);
	set[loc] unused = {};
	
	for (loc e <- entities, !isBreaking(e, detects) || !isUsed(e, evol)) {		
		bool used = false;
		for (loc c <- transEntities[e], !used) {
			if (isUsed(c, evol)) {
				used = true;
			}
		}
		
		if (!used) {
			unused += e;
		}
		
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
	
private set[TransChangedEntity] getTransEntities(Evolution evol, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	return { *getTransEntities(e, evol, ch) | loc e <- entities };
}

private set[TransChangedEntity] getTransEntities(loc elem, Evolution evol, CompatibilityChange ch) {
	set[TransChangedEntity] transEntities = {};
	
	if (classRemoved(binaryCompatibility=false,sourceCompatibility=false) := ch
		|| classTypeChanged(binaryCompatibility=false,sourceCompatibility=false) := ch) {
		; // skip 
	}
	else if (methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false) := ch
		|| methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false) := ch) {
		parent = parentType(evol.apiOld, elem);
		transEntities += { elem } * getSubtypes(parent, evol.apiOld)
				+ <elem, parent>;
	}
	else if (classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false) := ch
		|| classLessAccessible(binaryCompatibility=false,sourceCompatibility=false) := ch) {
		transEntities += getTransTypeEntitiesNoCons(elem, evol);
	}
	else if (classNowAbstract(binaryCompatibility=false,sourceCompatibility=false) := ch
		|| classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false) := ch
		|| classNowFinal(binaryCompatibility=false,sourceCompatibility=false) := ch
		|| interfaceAdded(binaryCompatibility=true,sourceCompatibility=false) := ch
		|| interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false) := ch
		|| superclassAdded(binaryCompatibility=true,sourceCompatibility=false) := ch
		|| superclassRemoved(binaryCompatibility=false,sourceCompatibility=false) := ch) {
		transEntities += getTransTypeEntities(elem, evol);
	}
	else if (isType(elem)) {
		transEntities += getTransTypeEntities(elem, evol);
	}
	else if (isMethod(elem)) {
		transEntities += getTransMethEntities(elem, evol);
	}
	else if (isField(elem)) {
		transEntities += getTransFieldEntities(elem, evol);
	}
	
	transEntities += <elem, elem>; // Add itself (in case it is not included in previous tuples)
	return transEntities;
}

private set[TransChangedEntity] getTransTypeEntities(loc elem, Evolution evol) {	
	set[TransChangedEntity] transFields = getContainedFields(evol.apiOld, elem);
	set[TransChangedEntity] transMeths = getContainedMethods(evol.apiOld, elem);
	set[TransChangedEntity] subtypes = { elem } * getSubtypes(elem, evol.apiOld);
	return transFields + transMeths + subtypes;
}

private set[TransChangedEntity] getTransTypeEntitiesNoCons(loc elem, Evolution evol) {	
	set[TransChangedEntity] transFields = getContainedFields(evol.apiOld, elem);
	set[TransChangedEntity] transMeths = getContainedMethods(evol.apiOld, elem) - getContainedConstructors(evol.apiOld, elem);
	set[TransChangedEntity] subtypes = { elem } * getSubtypes(elem, evol.apiOld);
	return transFields + transMeths;
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