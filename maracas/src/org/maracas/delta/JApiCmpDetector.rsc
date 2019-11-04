module org::maracas::delta::JApiCmpDetector

import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;
import org::maracas::m3::Inheritance;
import Relation;
import Set;
import String;
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

data Evolution = evolution(
	M3 client, 
	M3 apiOld, 
	M3 apiNew, 
	list[APIEntity] delta
);

alias TransChangedEntity = tuple[loc main, loc trans];

alias RippleEffect = tuple[loc changed, loc affected];
	
	
//----------------------------------------------
// Functions
//----------------------------------------------

// Use this function instead of directly calling the
// Evolution constructor. 
Evolution createEvolution(M3 client, M3 apiOld, M3 apiNew, list[APIEntity] delta) {
	client = filterConstructorOverride(client); // TODO: remove once a decision is taken in the M3 side
	return evolution(client, apiOld, apiNew, delta);
}

set[Detection] detections(Evolution evol)
	= computeDetections(evol, fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
	+ computeDetections(evol, methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
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
	+ computeDetections(evol, classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
	+ computeDetections(evol, classRemoved(binaryCompatibility=false,sourceCompatibility=false))
	;

set[Detection] detections(M3 client, M3 apiOld, M3 apiNew, list[APIEntity] delta) {
	Evolution evol = createEvolution(client, apiOld, apiNew, delta);
	return detections(evol);
}


//----------------------------------------------
// Field detections
//----------------------------------------------

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldLessAccessible()) 
	= computeFieldSymbDetections(evol, ch, isLessAccessible);

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::fieldNoLongerStatic()) 
	= computeFieldSymbDetections(evol, ch);

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
	return computeFieldSymbDetections(evol, changed, change, predicate);
}

set[Detection] computeFieldSymbDetections(Evolution evol, set[loc] changed, CompatibilityChange change)
	 = computeFieldSymbDetections(evol, changed, change, bool (RippleEffect effect, Evolution evol) { return true; });
	 
set[Detection] computeFieldSymbDetections(Evolution evol, set[loc] changed, CompatibilityChange change, bool (RippleEffect, Evolution) predicate) {
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


//----------------------------------------------
// Method detections
//----------------------------------------------

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodLessAccessible())
	= computeMethSymbDetections(evol, ch, { methodInvocation() }, isLessAccessible)
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, isLessAccessible, allowShadowing = true);
	

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNoLongerStatic()) 
	= computeDetections(evol, ch, { methodInvocation() });

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowAbstract())
	= computeTypeHierarchyDetections(evol, ch, { extends(), implements() }, isAffectedByAbsMeth)
	+ computeMethSymbDetections(evol, ch, { methodInvocation() });

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowFinal()) 
	= computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);
	
set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::methodNowStatic()) 
	= computeMethSymbDetections(evol, ch, { methodInvocation() })
	+ computeMethSymbDetections(evol, ch, { methodOverride() }, allowShadowing = true);
	
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
		set[loc] subtypes = getHierarchyWithoutMethShadowing(parent, signature, evol.apiOld, evol.client);
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
		set[loc] subtypes = getHierarchyWithoutMethShadowing(parent, signature, evol.apiNew, evol.client); // Diff evol.apiNew
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
		set[loc] symbMeths = createHierarchyMethSymbRefs(parent, signature, evol.apiOld, evol.client, allowShadowing = allowShadowing);
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
		annotation(), 
		extends(), 
		implements(), 
		typeDependency(), 
		methodInvocation(), 
		methodOverride(), 
		fieldAccess()
	};
	
	set[loc] transMeths = range(getTransitiveMethods(evol.apiOld, entities));
	set[loc] transFields = range(getTransitiveFields(evol.apiOld, entities));
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
	set[TransChangedEntity] transCons = getTransitiveConstructors(evol.apiOld, entities);
	return computeDetections(evol, transCons, ch, { methodInvocation() });
}

set[Detection] computeDetections(Evolution evol, ch:CompatibilityChange::classNowFinal()) {
	set[loc] entities = getChangedEntities(evol.delta, ch);
	set[loc] transMeths = range(getTransitiveMethods(evol.apiOld, entities)); // Don't like diff between set[loc] and set[TransChangedEntity]
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
	
	return computeDetections(evol, entities, ch, apiUses);
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
	
	for (e <- changed) {
		APIEntity entity = entityFromLoc(e, evol.delta);
		tuple[ClassType, ClassType] types = classModifiedType(entity);
		
		switch(types) {
		case <class(), _> :	entitiesExt += e;
		case <interface(), _> : {
			entitiesExt += e;
			entitiesImp += e;
		}
		case <annotation(), _> : entitiesAnn += e;
		default: ;
		}
	}
	
	//  computeDetections(evol, entitiesExt, ch, { extends() }, isInterNotExtendAnn)
	return computeDetections(evol, entitiesExt, ch, { extends() })
		+ computeDetections(evol, entitiesImp, ch, { implements() })
		+ computeDetections(evol, entitiesAnn, ch, { annotation() });
}


//----------------------------------------------
// General logic
//----------------------------------------------

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
	
	for (used <- changed) {
		set[loc] transChanged = entities[used] + used;
		rel[loc, APIUse] affected = { *getAffectedEntities(evol.client, apiUse, transChanged) | apiUse <- apiUses };
		detects += { detection(elem, used, apiUse, change) | <elem, apiUse> <- affected, predicate(<used, elem>, evol) };
	}
	
	return detects;
}

private set[Detection] computeDetections(Evolution evol, set[loc] entities, CompatibilityChange change, set[APIUse] apiUses) 
	= computeDetections(evol, entities, change, apiUses, bool (RippleEffect effect, Evolution evol) { return true; });

private set[Detection] computeDetections(Evolution evol, set[loc] entities, CompatibilityChange change, set[APIUse] apiUses, bool (RippleEffect, Evolution) predicate) {
	set[Detection] detects = {};
	
	for (used <- entities) {
		rel[loc, APIUse] affected = { *getAffectedEntities(evol.client, apiUse, { used }) | apiUse <- apiUses };
		detects += { detection(elem, used, apiUse, change) | <elem, apiUse> <- affected, predicate(<used, elem>, evol) };
	}
	
	return detects;
}

private set[TransChangedEntity] getTransitiveEntities(M3 m, set[loc] entities, bool (loc) fun) {
	rel[loc, loc] transContain = m.containment+;
	return { <e, c> | e <- entities, c <- transContain[e], fun(c) };
}

private set[TransChangedEntity] getTransitiveConstructors(M3 m, set[loc] entities) 
	= getTransitiveEntities(m, entities, isConstructor);

private set[TransChangedEntity] getTransitiveMethods(M3 m, set[loc] entities) 
	= getTransitiveEntities(m, entities, isMethod);

private set[TransChangedEntity] getTransitiveFields(M3 m, set[loc] entities) 
	= getTransitiveEntities(m, entities, isField);

private bool isLessAccessible(RippleEffect effect, Evolution evol) {
	tuple[Modifier old, Modifier new] access = getAccessModifiers(effect.changed, evol.delta);
	bool pub2prot = isChangedFromPublicToProtected(access.old, access.new);
	bool pkgProt = isPackageProtected(access.new);
		
	return isLessVisible(access.new, access.old)
		&& !(pub2prot && hasProtectedAccess(effect, evol)) // Public to protected
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
		&& !(pub2prot && hasProtectedAccess(effect, evol)) // Public to protected
		&& !(pkgProt && samePackage(parent, changed)); // To package-private same package
}

private bool hasProtectedAccess(RippleEffect effect, Evolution evol) {
	loc apiParent = parentType(evol.apiOld, effect.changed);
	loc clientParent = parentType(evol.client, effect.affected);
	
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
	= <effect.affected, \abstract()> notin evol.client.modifiers;
	
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