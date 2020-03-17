module org::maracas::delta::JApiCmpDetector

import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpStability;
import org::maracas::m3::Core;
import org::maracas::m3::Containment;
import org::maracas::m3::Inheritance;
import Relation;
import Set;
import String;
import IO;
import ValueIO;

//----------------------------------------------
// ADT
//----------------------------------------------

data Detection = detection (
	loc elem,
	loc used,
	loc src,
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
	| declaration()
	;

data Evolution = evolution(
	M3 client, 
	M3 apiOld, 
	M3 apiNew, 
	list[APIEntity] delta
);

alias TransChangedEntity = tuple[loc main, loc trans];

alias RippleEffect = tuple[loc changed, loc affected];
	
	
//----------------------------------------------
// Core
//----------------------------------------------

// Use this function instead of directly calling the
// Evolution constructor. 
Evolution createEvolution(M3 client, M3 apiOld, M3 apiNew, list[APIEntity] delta) {
	client = filterConstructorOverride(client); // TODO: remove once a decision is taken in the M3 side
	return evolution(client, apiOld, apiNew, delta);
}

// Handy method for Java foreign calls
Evolution createEvolution (loc clientJar, loc apiOldJar, loc apiNewJar, loc deltaPath) {
	M3 clientM3 = createM3FromJarFile(clientJar);
	M3 apiOldM3 = createM3FromJarFile(apiOldJar);
	M3 apiNewM3 = createM3FromJarFile(apiNewJar);
	list[APIEntity] delta = readBinaryValueFile(#list[APIEntity], deltaPath);

	return createEvolution(clientM3, apiOldM3, apiNewM3, delta);
}

set[Detection] computeDetections(M3 client, M3 apiOld, M3 apiNew, list[APIEntity] delta) {
	Evolution evol = createEvolution(client, apiOld, apiNew, delta);
	return computeDetections(evol);
}

set[Detection] computeDetections(Evolution evol)
	= computeDetections(evol, fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
	+ computeDetections(evol, classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, interfaceAdded(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, superclassAdded(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, superclassRemoved(binaryCompatibility=false,sourceCompatibility=false))
	;

map[CompatibilityChange, set[Detection]] getDetectionsByChange(set[Detection] detects) {
	map[CompatibilityChange, set[Detection]] mapDet = ();
	for (Detection d <- detects) {
		CompatibilityChange change = d.change;
		mapDet += ( change : (change in mapDet) ? mapDet[change] + d : { d } );
	}
	return mapDet;
}
	
set[Detection] getDetectionsByChange(set[Detection] detects, CompatibilityChange change)
	= { d | Detection d <- detects, d.change == change };


//----------------------------------------------
// Field detections
//----------------------------------------------

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldLessAccessible()) 
	= computeFieldSymbDetections(evol, ch, isLessAccessible);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldMoreAccessible()) 
	= computeFieldSymbDetections(evol, ch, { declaration() }, isMoreAccessible, allowShadowing = true); // JLS 13.4.8 Field Declarations

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNoLongerStatic()) 
	= computeFieldSymbDetections(evol, ch)
	+ computeFieldSymbDetections(evol, ch, { declaration() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.8 Field Declarations

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNowFinal()) 
	= computeFieldSymbDetections(evol, ch); 

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNowStatic()) 
	= computeFieldSymbDetections(evol, ch)
	+ computeFieldSymbDetections(evol, ch, { declaration() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.8 Field Declarations

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldRemoved()) 
	= computeFieldSymbDetections(evol, ch);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldTypeChanged()) 
	= computeFieldSymbDetections(evol, ch);
	
set[Detection] computeFieldSymbDetections(Evolution evol, CompatibilityChange change)
	= computeFieldSymbDetections(evol, change, bool (RippleEffect effect, Evolution evol) { return true; });

set[Detection] computeFieldSymbDetections(Evolution evol, CompatibilityChange change, bool (RippleEffect, Evolution) predicate, bool allowShadowing = false)
	= computeFieldSymbDetections(evol, change, { fieldAccess() }, predicate, allowShadowing = allowShadowing);
	
set[Detection] computeFieldSymbDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate, bool allowShadowing = false) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	return computeFieldSymbDetections(evol, changed, change, apiUses, predicate, allowShadowing = allowShadowing);
}

set[Detection] computeFieldSymbDetections(Evolution evol, set[loc] changed, CompatibilityChange change)
	 = computeFieldSymbDetections(evol, changed, change, { fieldAccess() }, bool (RippleEffect effect, Evolution evol) { return true; });
		 
set[Detection] computeFieldSymbDetections(Evolution evol, set[loc] changed, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate, bool allowShadowing = false) {
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str field = memberName(e);
		loc parent = parentType(evol.apiOld, e);
		set[loc] symbFields = createHierarchySymbRefs(parent, e.scheme, field, evol.apiOld, evol.client, allowShadowing = allowShadowing);
		entities += { e } * symbFields;
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate);
}

set[Detection] computeFieldSymbDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, bool includeParent = true)
	 = computeFieldSymbDetections(evol, entities, change, bool (RippleEffect effect, Evolution evol) { return true; }, includeParent = includeParent);
	 
set[Detection] computeFieldSymbDetections(Evolution evol, set[TransChangedEntity] chEntities, CompatibilityChange change, bool (RippleEffect, Evolution) predicate, bool includeParent = true) {
	set[APIUse] apiUses = { fieldAccess() };
	set[loc] changed = domain(chEntities);
	set[TransChangedEntity] entities = {}; 
	
	for (loc used <- changed) {
		set[loc] transChanged = chEntities[used];
		
		for (loc e <- transChanged) {
			str field = memberName(e);
			loc parent = parentType(evol.apiOld, e);
			set[loc] symbFields = createHierarchySymbRefs(parent, e.scheme, field, evol.apiOld, evol.client, includeParent = includeParent);
			entities += { used } * symbFields;
		}
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate);
}


//----------------------------------------------
// Method detections
//----------------------------------------------

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodLessAccessible())
	= computeMethSymbDetections(evol, ch, { methodInvocation() }, isLessAccessible)
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, isLessAccessible, allowShadowing = true);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodMoreAccessible())
	= computeMethSymbDetections(evol, ch, { methodOverride() }, isMoreAccessible, allowShadowing = true);	

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNoLongerStatic()) 
	= computeDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.12 Method and Constructor Declarations

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowAbstract())
	= computeTypeHierarchyDetections(evol, ch, { extends(), implements() }, isAffectedByAbsMeth)
	+ computeMethSymbDetections(evol, ch, { methodInvocation() });

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowFinal()) 
	= computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowStatic()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.12 Method and Constructor Declarations
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowThrowsCheckedException()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() });

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodRemoved()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodReturnTypeChanged()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodAbstractAddedToClass()) 
	= computeTypeHierarchyDetectionsNewApi(evol, ch, { extends() }, isNotAbstract);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodAddedToInterface()) 
	= computeTypeHierarchyDetectionsNewApi(evol, ch, { implements() }, isNotAbstract);
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodAbstractNowDefault())
	= computeTypeHierarchyDetectionsNewApi(evol, ch, { implements() }, existsMethodClash);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNewDefault())
	= computeTypeHierarchyDetectionsNewApi(evol, ch, { implements() }, existsMethodClash);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::constructorLessAccessible())
	= computeMethSymbDetections(evol, ch, { methodInvocation() }, isLessAccessible)
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, isLessAccessible, allowShadowing = true);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::constructorRemoved()) 
	= computeDetections(evol, ch, { methodInvocation() });
	
// TODO: refactor it
set[Detection] computeTypeHierarchyDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses)
	= computeTypeHierarchyDetections(evol, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

set[Detection] computeTypeHierarchyDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str signature = methodSignature(e);
		loc parent = parentType(evol.apiOld, e);
		set[loc] subtypes = getHierarchyWithoutMethShadowing(parent, e.scheme, signature, evol.apiOld, evol.client);
		entities += { e } * subtypes;
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate);
}

// TODO: refactor it
set[Detection] computeTypeHierarchyDetectionsNewApi(Evolution evol, CompatibilityChange change, set[APIUse] apiUses)
	= computeTypeHierarchyDetectionsNewApi(evol, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

set[Detection] computeTypeHierarchyDetectionsNewApi(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str signature = methodSignature(e);
		loc parent = parentType(evol.apiNew, e); // Diff evol.apiNew
		set[loc] subtypes = getHierarchyWithoutMethShadowing(parent, e.scheme, signature, evol.apiNew, evol.client); // Diff evol.apiNew
		entities += { e } * subtypes;
	}
		
	return computeDetections(evol, entities, change, apiUses, predicate);
}

set[Detection] computeMethSymbDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool allowShadowing = false)
	= computeMethSymbDetections(evol, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; }, allowShadowing = allowShadowing);
	
set[Detection] computeMethSymbDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate, bool allowShadowing = false) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	return computeMethSymbDetections(evol, changed, change, apiUses, predicate, allowShadowing = allowShadowing);
}

set[Detection] computeMethSymbDetections(Evolution evol, set[loc] changed, CompatibilityChange change, set[APIUse] apiUses, bool allowShadowing = false)
	= computeMethSymbDetections(evol, changed, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; }, allowShadowing = allowShadowing);
	
set[Detection] computeMethSymbDetections(Evolution evol, set[loc] changed, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate, bool allowShadowing = false) {
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str signature = methodSignature(e);
		loc parent = parentType(evol.apiOld, e);
		set[loc] symbMeths = createHierarchySymbRefs(parent, e.scheme, signature, evol.apiOld, evol.client, allowShadowing = allowShadowing);
		entities += { e } * symbMeths;
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate);
}

set[Detection] computeMethSymbDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses, bool allowShadowing = false, bool includeParent = true)
	= computeMethSymbDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; }, allowShadowing = allowShadowing, includeParent = includeParent);

set[Detection] computeMethSymbDetections(Evolution evol, set[TransChangedEntity] chEntities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate, bool allowShadowing = false, bool includeParent = true) {
	set[loc] changed = domain(chEntities);
	set[TransChangedEntity] entities = {}; 
	
	for (loc used <- changed) {
		set[loc] transChanged = chEntities[used];
		
		for (loc e <- transChanged) {
			str signature = methodSignature(e);
			loc parent = parentType(evol.apiOld, e);
			set[loc] symbMeths = createHierarchySymbRefs(parent, e.scheme, signature, evol.apiOld, evol.client, allowShadowing = allowShadowing, includeParent = includeParent);
			entities += { used } * symbMeths;
		}
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate);
}


//----------------------------------------------
// Class detections
//----------------------------------------------

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::annotationDeprecatedAdded()) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[APIUse] apiUses = { 
		annotation(), 
		extends(), 
		implements(), 
		typeDependency(), 
		methodInvocation(), 
		methodOverride(), 
		fieldAccess()
	};
	
	set[TransChangedEntity] transMeths = getContainedMethods(evol.apiOld, entities);
	set[TransChangedEntity] transFields = getContainedFields(evol.apiOld, entities);
	set[APIUse] apiUsesFields = { fieldAccess() };
	
	return computeDetections(evol, ch, apiUses)
		+ computeFieldSymbDetections(evol, transFields, ch)
		+ computeMethSymbDetections(evol, transMeths, ch, { methodInvocation() })
		+ computeMethSymbDetections(evol, transMeths, ch, { methodOverride() }, allowShadowing = true);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classLessAccessible()) {
	set[APIUse] apiUses = { typeDependency(), extends(), implements(), APIUse::annotation() };
	return computeDetections(evol, ch, apiUses, isClassLessAccessible);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classNoLongerPublic()) {
	set[APIUse] apiUses = { typeDependency(), extends(), implements(), APIUse::annotation() };
	return computeDetections(evol, ch, apiUses, isClassLessAccessible);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classNowAbstract()) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[TransChangedEntity] transCons = getContainedConstructors(evol.apiOld, entities);
	return computeDetections(evol, transCons, ch, { methodInvocation() }, isNotSuperInvocation);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classNowFinal()) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[TransChangedEntity] transMeths = getContainedMethods(evol.apiOld, entities);
	return computeDetections(evol, ch, { extends() })
		+ computeMethSymbDetections(evol, transMeths, ch, { methodOverride() }, allowShadowing = true);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classNowCheckedException()) {
	set[loc] changed = getChangedEntities(evol.delta, ch);
	set[APIUse] apiUses = { methodInvocation() };
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		set[loc] clientCons = { *constructors(evol.client, s) | s <- getClientConcreteSubtypes(e, evol.apiOld, evol.client) };
		set[loc] apiCons = { *constructors(evol.apiOld, s) | s <- getConcreteSubtypes(e, evol.apiOld) };
		set[loc] cons = clientCons + apiCons + constructors(evol.apiOld, e);
		
		entities += { e } * cons;
	}
	
	return computeDetections(evol, entities, ch, apiUses, isNotSuperInvocation);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classRemoved()) {
	set[APIUse] apiUses = { typeDependency(), extends(), implements(), APIUse::annotation() };
	return computeDetections(evol, ch, apiUses);
}
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classTypeChanged()) {
	set[loc] changed = getChangedEntities(evol.delta, ch);
	set[loc] entitiesExt = {};
	set[loc] entitiesImp = {};
	set[loc] entitiesAnn = {};
	
	for (loc e <- changed) {
		APIEntity entity = getEntityFromLoc(e, evol.delta);
		tuple[ClassType, ClassType] types = getClassModifiedType(entity);
		
		switch(types) {
		case <class(), _> :	entitiesExt += e;
		case <interface(), annotation()> : entitiesImp += e; // Do not include extends
		case <interface(), _> : {
			entitiesExt += e;
			entitiesImp += e;
		}
		case <annotation(), _> : entitiesAnn += e;
		default: ;
		}
	}
	
	return computeDetections(evol, entitiesExt, ch, { extends() })
		+ computeDetections(evol, entitiesImp, ch, { implements() })
		+ computeDetections(evol, entitiesAnn, ch, { annotation() });
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::interfaceRemoved()) {
	rel[loc, loc] changed = getInterRemovedEntities(evol.delta);
	return computeSuperRemovedDetections(evol, changed, ch);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::interfaceAdded()) {
	rel[loc, loc] changed = getInterAddedEntities(evol.delta);
	return computeSuperAddedDetections(evol, changed, ch);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::superclassRemoved()) {
	rel[loc, loc] changed = getSuperRemovedEntities(evol.delta);
	return computeSuperRemovedDetections(evol, changed, ch);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::superclassAdded()) {
	rel[loc, loc] changed = getSuperAddedEntities(evol.delta);
	return computeSuperAddedDetections(evol, changed, ch);
}

set[Detection] computeSuperAddedDetections(Evolution evol, rel[loc, loc] changed, CompatibilityChange ch) {
	set[loc] entitiesAbs = { c | <loc c, loc i> <- changed, isAbstract(c, evol.apiNew), abstractMeths(evol.apiNew, i) != {} };
	set[TransChangedEntity] entities = { *( { e } * (getAbstractSubtypes(e, evol.apiNew) + e)) | loc e <- entitiesAbs };
	return computeDetections(evol, entities, ch, { extends(), implements() }, isNotAbstract);
}

set[Detection] computeSuperRemovedDetections(Evolution evol, rel[loc, loc] changed, CompatibilityChange ch) {
	rel[loc, loc] entitiesAbs = { <c, i> | <loc c, loc i> <- changed, isAbstract(c, evol.apiNew) };
	set[TransChangedEntity] transFields = getContainedFields(evol.apiOld, range(changed));
	set[TransChangedEntity] transMeths = getContainedMethods(evol.apiOld, range(changed));
	set[TransChangedEntity] absMeths = { <e, m> | <loc e, loc i> <- entitiesAbs, loc m <- methods(evol.apiOld, i), isAbstract(m, evol.apiOld) };

	return computeMethSymbDetections(evol, absMeths, ch, { methodOverride() }, allowShadowing = true)
		+ computeMethSymbDetections(evol, transMeths, ch, { methodInvocation() }, includeParent = false)
		+ computeFieldSymbDetections(evol, transFields, ch, includeParent = false);
}


//----------------------------------------------
// Util
//----------------------------------------------

private rel[loc, APIUse] getAffectedEntities(M3 client, APIUse apiUse, set[loc] entities) {
	set[loc] affected = {};
	
	if (apiUse == APIUse::annotation()) {
		affected = domainRangeR(client.annotations, entities);
	}
	elseif (apiUse == declaration()) {
		affected = domain(domainR(client.declarations, entities));
	}
	elseif (apiUse == extends()) {
		affected = domainRangeR(client.extends, entities);
	}
	elseif (apiUse == fieldAccess()) {
		affected = domainRangeR(client.fieldAccess, entities);
	}
	elseif (apiUse == implements()) {
		affected = domainRangeR(client.implements, entities);
	}
	elseif (apiUse == methodInvocation()) {
		affected = domainRangeR(client.methodInvocation, entities);
	}
	elseif (apiUse == methodOverride()) {
		affected = domainRangeR(client.methodOverrides, entities);
	}
	elseif (apiUse == typeDependency()) {
		raw = domainRangeR(client.typeDependency, entities);
		for (loc e <- raw) {
			affected += (isParameter(e)) ? getMethod(e) : e; // Parameters special treatment
		}
	}
	else { 
		throw "Wrong APIUse for member type: <apiUse>";
	}

	return affected * { apiUse };
}

private set[Detection] computeDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses)
	= computeDetections(evol, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

private set[Detection] computeDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[loc] entities = getChangedEntities(evol.delta, change);
	return computeDetections(evol, entities, change, apiUses, predicate);
}

private set[Detection] computeDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses) 
	= computeDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

private set[Detection] computeDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[loc] changed = domain(entities);
	set[Detection] detects = {};
	
	for (loc src <- changed) {
		set[loc] transChanged = entities[src] + src;
		
		for (loc used <- transChanged) {
			rel[loc, APIUse] affected = { *getAffectedEntities(evol.client, apiUse, { used } ) | apiUse <- apiUses };
			detects += { detection(elem, used, src, apiUse, change) | <elem, apiUse> <- affected, predicate(<src, elem>, evol) };
		}
	}
	
	return detects;
}

private set[Detection] computeDetections(Evolution evol, set[loc] entities, CompatibilityChange change, set[APIUse] apiUses) 
	= computeDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

private set[Detection] computeDetections(Evolution evol, set[loc] entities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[Detection] detects = {};
	
	for (loc used <- entities) {
		rel[loc, APIUse] affected = { *getAffectedEntities(evol.client, apiUse, { used }) | apiUse <- apiUses };
		detects += { detection(elem, used, used, apiUse, change) | <elem, apiUse> <- affected, predicate(<used, elem>, evol) };
	}
	
	return detects;
}

private bool isNotSuperInvocation(RippleEffect effect, Evolution evol) 
	= !(isConstructor(effect.affected) && areInSameHierarchy(effect, evol));

private bool isLessAccessible(RippleEffect effect, Evolution evol) {
	tuple[Modifier old, Modifier new] access = getAccessModifiers(effect.changed, evol.delta);
	bool pub2prot = isChangedFromPublicToProtected(access.old, access.new);
	bool pkgProt = isPackageProtected(access.new);
		
	return isLessVisible(access.new, access.old)
		&& !(pub2prot && areInSameHierarchy(effect, evol)) // Public to protected
		&& !(pkgProt && samePackage(effect.affected, effect.changed)); // To package-private same package
}

private bool isClassLessAccessible(RippleEffect effect, Evolution evol) {
	tuple[Modifier old, Modifier new] access = getAccessModifiers(effect.changed, evol.delta);
	bool pub2prot = isChangedFromPublicToProtected(access.old, access.new);
	bool pkgProt = isPackageProtected(access.new);
	
	loc affected = effect.affected;
	loc changed = effect.changed;
	loc parent = (isType(affected)) ? affected : parentType(evol.client, affected);
	
	return isLessVisible(access.new, access.old)
		&& !(pub2prot && areInSameHierarchy(effect, evol)) // Public to protected
		&& !(pkgProt && samePackage(parent, changed)); // To package-private same package
}

private bool isMoreAccessible(RippleEffect effect, Evolution evol) {
	tuple[Modifier old, Modifier new] accessApi = getAccessModifiers(effect.changed, evol.delta);
	set[Modifier] modifsClient = getAccessModifier(effect.affected, evol.client);
	Modifier accessClient = (modifsClient == {}) ? \packageProtected() : getOneFrom(modifsClient);
	return isMoreVisible(accessApi.new, accessApi.old) && isLessVisible(accessClient, accessApi.new);
}

private bool areStaticIncompatible(RippleEffect effect, Evolution evol) {
	set[Modifier] modifsApi = getStaticModifier(effect.changed, evol.apiNew);
	set[Modifier] modifsClient = getStaticModifier(effect.affected, evol.client);
	Modifier modifClient = (modifsClient == {}) ? \nonStatic() : getOneFrom(modifsClient);
	Modifier modifApi = (modifsClient == {}) ? \nonStatic() : getOneFrom(modifsClient);
	return modifClient == modifApi;
}

private bool areInSameHierarchy(RippleEffect effect, Evolution evol) {
	loc apiParent = (isType(effect.changed)) ? effect.changed : parentType(evol.apiOld, effect.changed);
	loc clientParent = (isType(effect.affected)) ? effect.affected : parentType(evol.client, effect.affected);
	
	return (isKnown(clientParent) && isKnown(apiParent) 
		&& <clientParent, apiParent> in composeExtends({ evol.client, evol.apiOld })+);
}

private bool isAffectedByAbsMeth(RippleEffect effect, Evolution evol)
	= isNotAbstract(effect, evol) && !hasMethodOverride(effect, evol);

private bool hasMethodOverride(RippleEffect effect, Evolution evol) {
	//Get method declarations
	set[loc] methods = methodDeclarations(evol.client, effect.affected);
		
	// If there is a method override, no problem should be detected
	if (m <- methods, sameMethodSignature(m, effect.changed)) {
		return true;
	}
	return false;
}

private bool isNotAbstract(RippleEffect effect, Evolution evol)
	= !isAbstract(effect.affected, evol.client);

private bool existsMethodClash(RippleEffect effect, Evolution evol) {
	loc affected = effect.affected;
	loc changed = effect.changed;
	set[loc] interfaces = evol.client.implements[affected];
	
	if (size(interfaces) > 1) {		
		// If there is a method override, no problem should be detected
		if (hasMethodOverride(effect, evol)) {
			return false;
		}
		
		if (i <- interfaces, hasSameMethod(evol.client, i, changed) 
			|| hasSameMethod(evol.apiNew, i, changed)) {
			return true;
		}
	}
	return false;	
}

private bool hasSameMethod(M3 m, loc class, loc meth) {
	set[loc] methods = methodDeclarations(m, class);
	if (e <- methods, sameMethodSignature(e, meth)) {
		return true;
	}
	return false;
}

// Handy method for Java foreign calls
public set[Detection] computeDetections(loc clientJar, loc apiOldJar, loc apiNewJar, loc deltaPath) {
	M3 clientM3 = createM3FromJarFile(clientJar);
	M3 apiOldM3 = createM3FromJarFile(apiOldJar);
	M3 apiNewM3 = createM3FromJarFile(apiNewJar);
	list[APIEntity] delta = readBinaryValueFile(#list[APIEntity], deltaPath);

	return computeDetections(createEvolution(clientM3, apiOldM3, apiNewM3, delta));
}

//----------------------------------------------
// Stability
//----------------------------------------------

set[Detection] filterStableDetectsByPkg(set[Detection] detects) 
	= { d | Detection d <- detects, !isUnstableAPI(d.src) };

set[Detection] filterUnstableDetectsByPkg(set[Detection] detects) 
	= { d | Detection d <- detects, isUnstableAPI(d.src) };

set[Detection] filterUnstableDetectsByAnnon(list[APIEntity] delta, set[Detection] detects) {
	rel[loc, loc] unstable = getAPIWithUnstableAnnon(delta);
	return filterUnstableDetectsByAnnon(unstable, detects);
} 

set[Detection] filterUnstableDetectsByAnnon(list[APIEntity] delta, set[Detection] detects, set[loc] annons) {
	rel[loc, loc] unstable = getAPIWithUnstableAnnon(delta, annons);
	return filterUnstableDetectsByAnnon(unstable, detects);
}

private set[Detection] filterUnstableDetectsByAnnon(rel[loc, loc] unstable, set[Detection] detects)
	= { d | Detection d <- detects, unstable[d.src] != {} };

rel[loc, Detection] getDetectsWithUnstableAnnon(list[APIEntity] delta, set[Detection] detects) {
	rel[loc, loc] unstable = getAPIWithUnstableAnnon(delta);
	return { <a, d> | Detection d <- detects, loc a <- unstable[d.src] };
}

rel[loc, Detection] getDetectsWithUnstableAnnon(list[APIEntity] delta, set[Detection] detects, set[loc] annons) {
	rel[loc, loc] unstable = getAPIWithUnstableAnnon(delta);
	return { <a, d> | Detection d <- detects, loc a <- unstable[d.src], a in annons };
}

set[loc] getUnstableAnnons(list[APIEntity] delta, set[Detection] detects) {
	rel[loc, Detection] unstable = getDetectsWithUnstableAnnon(delta, detects);
	return domain(unstable);
}