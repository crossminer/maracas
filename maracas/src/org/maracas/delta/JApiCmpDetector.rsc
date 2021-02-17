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
// Utility
//----------------------------------------------

set[Detection] readBinaryDetections(loc detects)
	= readBinaryValueFile(#set[Detection], detects);
	
set[CompatibilityChange] getCompatibilityChanges(set[Detection] detects) 
	= { d.change | Detection d <- detects };

set[loc] getSources(set[Detection] detects) 
	= { d.src | Detection d <- detects };
	
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
	M3 clientM3 = createM3(clientJar);
	M3 apiOldM3 = createM3(apiOldJar);
	M3 apiNewM3 = createM3(apiNewJar);
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

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldLessAccessible()) {
	set[loc] changed = getChangedEntities(evol.delta, ch);
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(e, evol.delta);
		bool pub2prot = isChangedFromPublicToProtected(access.old, access.new);

		if (!pub2prot) {
			str field = memberName(e);
			loc parent = parentType(evol.apiOld, e);
			set[loc] symbFields = createHierarchySymbRefs(parent, e.scheme, field, evol.apiOld, evol.client);
			entities += { e } * symbFields;
		}
		else {
			entities += <e, e>;
		}
	}
	
	return computeDetections(evol, entities, ch, { fieldAccess() }, isLessAccessible);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldMoreAccessible()) 
	= computeFieldSymbDetections(evol, ch, { declaration() }, isMoreAccessible, allowShadowing = true); // JLS 13.4.8 Field Declarations

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNoLongerStatic()) {
	x = computeFieldSymbDetections(evol, ch, { declaration() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.8 Field Declarations
	return computeFieldSymbDetections(evol, ch)
	+ computeFieldSymbDetections(evol, ch, { declaration() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.8 Field Declarations
}

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

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodLessAccessible()) {
	return computeMethLessAccessibleDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, isLessAccessible, allowShadowing = true);
}

set[Detection] computeMethLessAccessibleDetections(Evolution evol, ch:CompatibilityChange::methodLessAccessible(), set[APIUse] apiUses) {
	set[loc] changed = getChangedEntities(evol.delta, ch);
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(e, evol.delta);
		bool pub2prot = isChangedFromPublicToProtected(access.old, access.new);
	
		if (!pub2prot) {
			str signature = methodSignature(e);
			loc parent = parentType(evol.apiOld, e);
			set[loc] symbMeths = createHierarchySymbRefs(parent, e.scheme, signature, evol.apiOld, evol.client);
			entities += { e } * symbMeths;
		}
		else {
			entities += <e, e>;
		}
	}
	
	return computeDetections(evol, entities, ch, apiUses, isLessAccessible);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodMoreAccessible())
	= computeMethSymbDetections(evol, ch, { methodOverride() }, isMoreAccessible, allowShadowing = true);	

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNoLongerStatic()) {
	return computeDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { declaration() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.12 Method and Constructor Declarations
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowAbstract())
	= computeTypeHierarchyDetections(evol, ch, { extends(), implements() }, isAffectedByAbsMeth)
	+ computeMethSymbDetections(evol, ch, { methodInvocation() });

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowFinal()) 
	= computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowStatic()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, areStaticIncompatible, allowShadowing = true); // JLS 13.4.12 Method and Constructor Declarations
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowThrowsCheckedException()) {
	set[loc] changed = domain(getExcepRemovedEntities(evol.delta) + getExcepAddedEntities(evol.delta));
	return computeMethSymbDetections(evol, changed, ch, { methodInvocation(), methodOverride() }, bool (RippleEffect effect, Evolution evol) { return true; });
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodRemoved()) 
	= computeMethRemDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);

set[Detection] computeMethRemDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str signature = methodSignature(e);
		loc parent = parentType(evol.apiOld, e);
		set[loc] symbMeths = createHierarchySymbRefs(parent, e.scheme, signature, evol.apiOld, evol.client);
		set[loc] filterSymbMeths = { s | loc s <- symbMeths, evol.apiNew.declarations[s] == {} };
		entities += { e } * filterSymbMeths;
	}
	
	return computeDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });
}
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodReturnTypeChanged()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodAbstractAddedToClass()) 
	= computeAbsTypeHierarchyDetections(evol, ch, { extends() }, isNotAbstract);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodAddedToInterface()) 
	= computeAbsTypeHierarchyDetections(evol, ch, { implements() }, isNotAbstract);
	
set[Detection] computeAbsTypeHierarchyDetections(Evolution evol, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[loc] changed = getChangedEntities(evol.delta, change);
	set[TransChangedEntity] entities = {}; 
	
	for (e <- changed) {
		str signature = methodSignature(e);
		loc parent = parentType(evol.apiNew, e); // Diff evol.apiNew
		
		if (!hasSupertypesWithShadowing(parent, e.scheme, signature, evol.apiOld)
			&& !hasSubtypesWithShadowing(parent, e.scheme, signature, evol.apiOld)) {
			set[loc] subtypes = getHierarchyWithoutMethShadowing(parent, e.scheme, signature, evol.apiNew, evol.client); // Diff evol.apiNew
			entities += { e } * subtypes;
		}
	}
		
	return computeDetections(evol, entities, change, apiUses, predicate);
}

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


//----------------------------------------------
// Class detections
//----------------------------------------------

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::annotationDeprecatedAdded()) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[APIUse] apiUses = { 
		APIUse::annotation(), 
		APIUse::extends(), 
		APIUse::implements(), 
		APIUse::typeDependency(), 
		APIUse::methodInvocation(), 
		APIUse::methodOverride(), 
		APIUse::fieldAccess()
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
	rel[loc, loc] changed = getInterRemovedEntities(evol.delta); // The content looks like: { <class, inter1>, <class, inter2>... }
	return computeSuperRemovedDetections(evol, changed, ch);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::interfaceAdded()) {
	rel[loc, loc] changed = getInterAddedEntities(evol.delta); // The content looks like: { <class, inter1>, <class, inter2>... }
	return computeSuperAddedDetections(evol, changed, ch);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::superclassRemoved()) {
	rel[loc, loc] changed = getSuperRemovedEntities(evol.delta); // The content looks like: { <class, superclass> }
	return computeSuperRemovedDetections(evol, changed, ch);
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::superclassAdded()) {
	rel[loc, loc] changed = getSuperAddedEntities(evol.delta); // The content looks like: { <class, superclass> }
	return computeSuperAddedDetections(evol, changed, ch);
}

set[Detection] computeSuperAddedDetections(Evolution evol, rel[loc, loc] changed, CompatibilityChange ch) {
	set[loc] entitiesAbs = { c | <loc c, loc i> <- changed, isAbstract(c, evol.apiNew), abstractMeths(evol.apiNew, i) != {} };
	set[TransChangedEntity] entities = { *( { e } * (getAbstractSubtypes(e, evol.apiNew) + e)) | loc e <- entitiesAbs };
	return computeDetections(evol, entities, ch, { extends(), implements() }, isNotAbstract);
}

set[Detection] computeSuperRemovedDetections(Evolution evol, rel[loc, loc] changed, CompatibilityChange ch) {
	// Get abstract classes out from the changed relation 
	rel[loc, loc] entitiesAbs = { <c, i> | <loc c, loc i> <- changed, isAbstract(c, evol.apiNew) };
	
	// Get interface/superclass (i.e. range(changed)) contained members
	set[TransChangedEntity] transFields = { <c, f> | <loc c, loc i> <- changed, <_, loc f> <- getContainedFields(evol.apiOld, { i }) }; // <super, field>
	set[TransChangedEntity] transMeths = { <c, m> | <loc c, loc i> <- changed, <_, loc m> <- getContainedMethods(evol.apiOld, { i }) }; // <super, method>
	
	// Get abstract methods from abstract classes 
	set[TransChangedEntity] absMeths = { <c, m> | <loc c, loc i> <- entitiesAbs, 
		loc m <- methods(evol.apiOld, i), isAbstract(m, evol.apiOld) };

	return computeMethSymbDetectionsSuper(evol, absMeths, ch, { methodOverride() }, allowShadowing = true)
		+ computeMethSymbDetectionsSuper(evol, transMeths, ch, { methodInvocation() }, includeParent = false) // This should be done only in child classes of impacted interface/superclass:s
		+ computeFieldSymbDetectionsSuper(evol, transFields, ch, includeParent = false);
}

set[Detection] computeMethSymbDetectionsSuper(Evolution evol, set[TransChangedEntity] chEntities, CompatibilityChange change, set[APIUse] apiUses, bool allowShadowing = false, bool includeParent = false)
	= computeMethSymbDetectionsSuper(evol, chEntities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; }, allowShadowing = allowShadowing, includeParent = includeParent);
	
set[Detection] computeMethSymbDetectionsSuper(Evolution evol, set[TransChangedEntity] chEntities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect effect, Evolution evol) predicate, bool allowShadowing = false, bool includeParent = true) {
	// Get impacted classes
	set[loc] changed = domain(chEntities); 
	set[TransChangedEntity] entities = {}; 
	
	for (loc used <- changed) {
		// Get interface/superclass' methods
		set[loc] transChanged = chEntities[used];
		
		for (loc e <- transChanged) {
			str signature = methodSignature(e);
			loc parent = parentType(evol.apiOld, e);
			set[loc] symbMeths = createHierarchySymbRefs(used, e.scheme, signature, evol.apiOld, evol.client, allowShadowing = allowShadowing, includeParent = includeParent) + { e };
			entities += { parent } * symbMeths;
		}
	}
	
	// Check only on subtypes!
	return computeDetections(evol, entities, change, apiUses, predicate, onlySubtypes = true);
}

set[Detection] computeFieldSymbDetectionsSuper(Evolution evol, set[TransChangedEntity] chEntities, CompatibilityChange change, bool includeParent = true)
	 = computeFieldSymbDetectionsSuper(evol, chEntities, change, bool (RippleEffect effect, Evolution evol) { return true; }, includeParent = includeParent);
		 
set[Detection] computeFieldSymbDetectionsSuper(Evolution evol, set[TransChangedEntity] chEntities, CompatibilityChange change, bool (RippleEffect effect, Evolution evol) predicate, bool includeParent = true) {
	set[APIUse] apiUses = { fieldAccess() };
	set[loc] changed = domain(chEntities);
	set[TransChangedEntity] entities = {}; 
	
	for (loc used <- changed) {
		set[loc] transChanged = chEntities[used];
		
		for (loc e <- transChanged) {
			str field = memberName(e);
			loc parent = parentType(evol.apiOld, e);
			set[loc] symbFields = createHierarchySymbRefs(used, e.scheme, field, evol.apiOld, evol.client, includeParent = includeParent) + { e };
			entities += { parent } * symbFields;
		}
	}
	
	return computeDetections(evol, entities, change, apiUses, predicate, onlySubtypes = true);
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
// Util
//----------------------------------------------

private rel[loc, APIUse] getAffectedEntities(Evolution evol, APIUse apiUse, set[TransChangedEntity] entities) {
	set[loc] affected = {};
	M3 client = evol.client;
	M3 apiOld = evol.apiOld;
	M3 comp = composeMaracasM3s(client.id, {apiOld, client});
	
	if (apiUse == APIUse::annotation()) {
		affected = { c | <loc p, loc e> <- entities, loc c <- client.invertedAnnotations[e], isSubtype(parentType(client, c), parentType(apiOld, e), comp) || parentType(apiOld, c) == parentType(apiOld, e) };
	}
	else if (apiUse == fieldAccess()) {
		affected = { c | <loc p, loc e> <- entities, loc c <- client.invertedFieldAccess[e], isSubtype(parentType(client, c), parentType(apiOld, e), comp) || parentType(apiOld, c) == parentType(apiOld, e) };
	}
	else if (apiUse == methodInvocation()) {
		affected = { c | <loc p, loc e> <- entities, loc c <- client.invertedMethodInvocation[e], isSubtype(parentType(client, c), parentType(apiOld, e), comp) || parentType(apiOld, c) == parentType(apiOld, e) };
	}
	else if (apiUse == methodOverride()) {
		affected = { c | <loc p, loc e> <- entities, loc c <- client.invertedMethodOverrides[e], isSubtype(parentType(client, c), parentType(apiOld, e), comp) || parentType(apiOld, c) == parentType(apiOld, e) };
	}
	else if (apiUse == typeDependency()) {
		raw = { c | <loc p, loc e> <- entities, loc c <- client.invertedTypeDependency[e], isSubtype(parentType(client, c), parentType(apiOld, e), comp) || parentType(apiOld, c) == parentType(apiOld, e) };
		for (loc e <- raw) {
			affected += (isParameter(e)) ? getMethod(e) : e; // Parameters special treatment
		}
	}
	else { 
		throw "Wrong APIUse for member type: <apiUse>";
	}

	return affected * { apiUse };
}

private rel[loc, APIUse] getAffectedEntities(M3 client, APIUse apiUse, set[loc] entities) {
	set[loc] affected = {};
	
	if (apiUse == APIUse::annotation()) {
		affected = client.invertedAnnotations[entities];
	}
	else if (apiUse == declaration()) {
		affected = { e | e <- entities, client.declarations[e] != {}};
	}
	else if (apiUse == extends()) {
		affected = client.invertedExtends[entities];
	}
	else if (apiUse == fieldAccess()) {
		affected = client.invertedFieldAccess[entities];
	}
	else if (apiUse == implements()) {
		affected = client.invertedImplements[entities];
	}
	else if (apiUse == methodInvocation()) {
		affected = client.invertedMethodInvocation[entities];
	}
	else if (apiUse == methodOverride()) {
		affected = client.invertedMethodOverrides[entities];
	}
	else if (apiUse == typeDependency()) {
		raw = client.invertedTypeDependency[entities];
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

private set[Detection] computeDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses, bool onlySubtypes = false) 
	= computeDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; }, onlySubtypes = onlySubtypes);

private set[Detection] computeDetections(Evolution evol, set[TransChangedEntity] entities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate, bool onlySubtypes = false) {
	set[loc] changed = domain(entities);
	set[Detection] detects = {};
	
	for (loc src <- changed) {
		set[loc] transChanged = entities[src] + src;
		
		for (loc used <- transChanged) {
			rel[loc, APIUse] affected = (onlySubtypes) ? { *getAffectedEntities(evol, apiUse, { <src, used> } ) | apiUse <- apiUses }
				: { *getAffectedEntities(evol.client, apiUse, { used } ) | apiUse <- apiUses };
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
	bool pkgProt = isPackageProtected(access.new);
	bool pub2prot = isChangedFromPublicToProtected(access.old, access.new);

	return isLessVisible(access.new, access.old)
		&& !(pub2prot && areInSameHierarchy(effect, evol))
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
		&& !(pkgProt && samePackage(parent, changed)) // To package-private same package
		&& !isInterface(parentType(evol.apiOld, changed)); // Do not consider interface declarations
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
	loc apiParent = (isType(effect.changed)) ? effect.changed 
		: parentType(evol.apiOld, effect.changed);
	loc clientParent = (isType(effect.affected)) ? effect.affected 
		: parentType(evol.client, effect.affected);
	
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
	M3 clientM3 = createM3(clientJar);
	M3 apiOldM3 = createM3(apiOldJar);
	M3 apiNewM3 = createM3(apiNewJar);
	list[APIEntity] delta = readBinaryValueFile(#list[APIEntity], deltaPath);

	return computeDetections(createEvolution(clientM3, apiOldM3, apiNewM3, delta));
}

//----------------------------------------------
// Stability
//----------------------------------------------

set[Detection] filterStableDetections(set[Detection] detects, list[APIEntity] delta) {
	set[loc] unstable = getAPIInUnstablePkg(delta) + domain(getAPIWithUnstableAnnon(delta));
	return { d | Detection d <- detects, d.src notin unstable };
}

set[Detection] filterUnstableDetections(set[Detection] detects, list[APIEntity] delta) {
	set[loc] unstable = getAPIInUnstablePkg(delta) + domain(getAPIWithUnstableAnnon(delta));
	return { d | Detection d <- detects, d.src in unstable };
}

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

bool isBreaking(loc elem, set[Detection] detects) {
	set[loc] srcs = getSources(detects);
	return elem in srcs;
}