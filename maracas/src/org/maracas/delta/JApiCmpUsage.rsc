module org::maracas::delta::JApiCmpUsage

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;


data Detection = detection (
	loc elem,
	loc used,
	APIUse use,
	CompatibilityChange change
);

set[loc] getUsedBreakingEntities(set[Detection] detects) 
	= { e | detection(_, loc e, _, _) <- detects };

set[loc] getUsedBreakingEntities(set[Detection] detects, CompatibilityChange ch) 
	= { e | detection(_, loc e, _, CompatibilityChange c) <- detects, c == ch };
		
set[loc] getUsedNonBreakingEntities(M3 client, list[APIEntity] delta, set[Detection] detects) {
	set[loc] entities = getChangedEntities(delta);
	set[loc] breaking = getUsedBreakingEntities(detects);
	return getUsedNonBreakingEntities(client, entities, breaking);
}

set[loc] getUsedNonBreakingEntities(M3 client, list[APIEntity] delta, set[Detection] detects, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(delta, ch);
	set[loc] breaking = getUsedBreakingEntities(detects, ch);
	return getUsedNonBreakingEntities(client, entities, breaking);
}

private set[loc] getUsedNonBreakingEntities(M3 client, set[loc] entities, set[loc] breaking) {
	set[loc] nonBreaking = entities - breaking;
	return { e | loc e <- nonBreaking, isUsed(e, client) };
}

set[loc] getUnusedChangedEntities(M3 client, list[APIEntity] delta) {
	set[loc] entities = getChangedEntities(delta);	
	return getUnusedChangedEntities(client, entities);
}

set[loc] getUnusedChangedEntities(M3 client, list[APIEntity] delta, CompatibilityChange ch) {
	set[loc] entities = getChangedEntities(delta, ch);	
	return getUnusedChangedEntities(client, entities);
}

private set[loc] getUnusedChangedEntities(M3 client, set[loc] entities) 
	= { e | loc e <- entities, !isUsed(e, client) };

bool isUsed(loc elem, M3 m) 
	= invertRel(m.annotations)[elem] != {}
	|| invertRel(client.extends)[elem] != {}
	|| invertRel(client.fieldAccess)[elem] != {}
	|| invertRel(client.implements)[elem] != {}
	|| invertRel(client.methodInvocation)[elem] != {}
	|| invertRel(client.methodOverrides)[elem] != {}
	|| invertRel(client.typeDependency)[elem] != {};