module org::maracas::delta::JApiCmpDetector

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


//----------------------------------------------
// Functions
//----------------------------------------------

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta) 
 	= detections(client, oldAPI, delta, annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true))
 	+ detections(client, oldAPI, delta, fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, fieldRemoved(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodNowFinal(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodNowStatic(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodRemoved(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, constructorRemoved(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classLessAccessible(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classNowAbstract(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classNowFinal(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classRemoved(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, delta, classTypeChanged(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, newAPI, delta, fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, newAPI, delta, methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false))
 	+ detections(client, oldAPI, newAPI, delta, methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false))
 	+ detections(client, oldAPI, newAPI, delta, methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false))
 	+ detections(client, oldAPI, newAPI, delta, methodNewDefault(binaryCompatibility=false,sourceCompatibility=false))
 	;
 	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::annotationDeprecatedAdded()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[APIUse] apiUses = { 
		annotation(), 
		extends(), 
		implements(), 
		typeDependency(), 
		methodInvocation(), 
		methodOverride(), 
		fieldAccess()
	};
	
	set[ChangedEntity] modifiedMeths = transitiveMethods(oldAPI, modified);
	set[APIUse] apiUsesMeths = { methodInvocation(), methodOverride() };
	
	set[ChangedEntity] modifiedFields = transitiveEntities(oldAPI, modified);
	set[APIUse] apiUsesFields = { fieldAccess() };
	
	return symbMethodDetectionsWithParent(client, oldAPI, modifiedMeths, apiUsesMeths)
		+ symbFieldDetections(client, oldAPI, modifiedFields, { fieldAccess() })
		+ detections(client, modified, apiUses);
}

private set[ChangedEntity] transitiveEntities(M3 oldAPI, set[ChangedEntity] modified, bool (loc) fun) {
	rel[loc, loc] transContain = oldAPI.containment+;
	return { <e, ch> | <m, ch> <- modified, e <- transContain[m], fun(e) };
}

private set[ChangedEntity] transitiveEntities(M3 oldAPI, set[ChangedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isAPIEntity);

private set[ChangedEntity] transitiveMethods(M3 oldAPI, set[ChangedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isMethod);

private set[ChangedEntity] transitiveConstructors(M3 oldAPI, set[ChangedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isConstructor);

private set[ChangedEntity] transitiveFields(M3 oldAPI, set[ChangedEntity] modified) 
	= transitiveEntities(oldAPI, modified, isField);

private set[ChangedEntity] transitiveSubtypes(M3 oldAPI, set[ChangedEntity] modified) {
	rel[loc, loc] transExtends = oldAPI.extends+;
	return { <e, ch> | <m, ch> <- modified, e <- transExtends[m], isType(e) };
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldLessAccessible()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[APIUse] apiUses = { fieldAccess() };
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(modif, delta);
		str field = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		
		set[loc] symbFields = subtypesFieldSymbolic(parent, field, client) 
			+ subtypesFieldSymbolic(parent, field, oldAPI)
			+ clientSubtypesFieldSymbolic(parent, field, oldAPI, client) + modif;
		
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbFields) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
			!(fromPublicToProtected(access.old, access.new) && hasProtectedAccess(client, oldAPI, elem, modif)), // Public to protected
			!(toPackageProtected(access.new) && samePackage(elem, modif)) }; // To package-private same package
	}
	return detects;
}

private bool toPackageProtected(Modifier new) 
	= new == org::maracas::delta::JApiCmp::\packageProtected();
	
private bool fromPublicToProtected(Modifier old, Modifier new) 
	= old == org::maracas::delta::JApiCmp::\public() 
	&& new == org::maracas::delta::JApiCmp::\protected();
	
private bool hasProtectedAccess(M3 client, M3 oldAPI, loc elemClient, loc elemAPI) {
	loc apiParent = parentType(oldAPI, elemAPI);
	loc clientParent = parentType(client, elemClient);
	return (isKnown(clientParent) && isKnown(apiParent) && <clientParent, apiParent> in client.extends+);
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNoLongerStatic()) 
	= fieldDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowFinal()) 
	= symbFieldDetections(client, oldAPI, delta, ch, { fieldAccess() }); 
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldNowStatic()) 
	= symbFieldDetections(client, oldAPI, delta, ch, { fieldAccess() });

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldRemoved()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch); 
	return symbFieldDetections(client, oldAPI, modified, { fieldAccess() }) 
		+ detections(client, oldAPI, modified, fieldRemovedInSuperclass()); // Pertaining fieldRemovedInSuperclass
}

set[Detection] detections(M3 client, M3 oldAPI, set[ChangedEntity] modified, ch:CompatibilityChange::fieldRemovedInSuperclass()) {
	CompatibilityChange change = fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false);
	return detectionsFieldRemovedInSuperclass(client, oldAPI, client.fieldAccess, modified, change, fieldAccess());
}
	
set[Detection] detectionsFieldRemovedInSuperclass(M3 client, M3 oldAPI, rel[loc, loc] m3Relation, set[ChangedEntity] modified, CompatibilityChange ch, APIUse apiUse) {
	set[Detection] detects = {};
	
	for (<modif, _> <- modified) {
		str fieldName = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		
		// Get modif subtypes and symbolic fields/methods
		set[loc] symbFields = subtypesFieldSymbolic(parent, fieldName, oldAPI) 
			+ clientSubtypesFieldSymbolic(parent, fieldName, oldAPI, client);
		// Get affected client members
		set[loc] affected = domain(rangeR(client.fieldAccess, symbFields));
		detects += { detection(elem, modif, apiUse, ch) | elem <- affected };
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldStaticAndOverridesStatic()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		// TODO: check cases where the field is not declared in the subtype
		loc parent = parentType(newAPI, modif);
		str fieldName = memberName(modif);
		
		// Get all subtypes of the modified type
		rel[loc, loc] transExtends = newAPI.extends+;
		set[loc] subtypes = domain(rangeR(transExtends, {parent}));
		
		// Compute locations of the affected field (cf. javac encoding)
		set[loc] fields = { |java+field:///| + "<s.path>/<fieldName>" | s <- subtypes } + modif;
		rel[loc, loc] invFieldAccess = invert(client.fieldAccess);
		detects += { detection(elem, modif, fieldAccess(), change) 
			| f <- fields, elem <- invFieldAccess[f] };
	}
	
	return detects;
}

// TODO: check immediate parent only?
private set[loc] overridenStaticFields(M3 newAPI, loc field) {
	rel[loc, loc] transExtends = newAPI.extends+;
	loc parent = parentType(field);
	set[loc] supers = transExtends[parent];
	set[loc] fields = { *fields(m3Client.containment[s]) | s <- supers };
	return { f | f <- fields, sameFieldName(field, f) };
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::fieldTypeChanged()) 
	= symbFieldDetections(client, oldAPI, delta, ch, { fieldAccess() });
	
private set[Detection] fieldDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, fieldAccess());
}

private set[Detection] symbFieldDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change, set[APIUse] apiUses) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return symbFieldDetections(client, oldAPI, modified, apiUses);
}

private set[Detection] symbFieldDetections(M3 client, M3 oldAPI, set[ChangedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str fieldName = memberName(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbFields = subtypesFieldSymbolic(parent, fieldName, oldAPI)
			+ subtypesFieldSymbolic(parent, fieldName, client) 
			+ clientSubtypesFieldSymbolic(parent, fieldName, oldAPI, client) + modif;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbFields) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

set[loc] subtypes(loc class, M3 m) 
	= invert(m.extends+) [class] + invert(m.implements+) [class];
	
set[loc] abstractSubtypes(loc class, M3 m) 
	= domain((subtypes(class, m) * { \abstract() }) & m.modifiers);
	
set[loc] concreteSubtypes(loc class, M3 m) 
	= subtypes(class, m) - abstractSubtypes(class, m);

set[loc] clientSubtypes(loc typ, M3 api, M3 client) {
	set[loc] apiSubtypes = subtypes(typ, api) + typ;
	return { *subtypes(s, client) | s <- apiSubtypes };
}

set[loc] clientAbstractSubtypes(loc typ, M3 api, M3 client) {
	set[loc] clientSubs = clientSubtypes(typ, api, client);
	return domain((clientSubs * { \abstract() }) & client.modifiers);
}

set[loc] clientConcreteSubtypes(loc typ, M3 api, M3 client)
	= clientSubtypes(typ, api, client) - clientAbstractSubtypes(typ, api, client);
	
private set[loc] subtypesWithoutShadowing(loc typ, str elemName, M3 m, loc (loc, str) funSymbRef) {
	set[loc] subtypes = domain(rangeR(m.extends, { typ })) + domain(rangeR(m.implements, { typ }));
	return { *(subtypesWithoutShadowing(s, elemName, m, funSymbRef) + s) 
		| s <- subtypes, m.declarations[funSymbRef(s, elemName)] == {} };
}

set[loc] subtypesWithoutFieldShadowing(loc typ, str signature, M3 m)
	= subtypesWithoutShadowing(typ, signature, m, fieldSymbolicRef);

set[loc] subtypesWithoutMethShadowing(loc typ, str signature, M3 m)
	= subtypesWithoutShadowing(typ, signature, m, methodSymbolicRef);

private set[loc] clientSubtypesWithoutShadowing(loc typ, str elemName, M3 api, M3 client, loc (loc, str) funSymbRef) {
	set[loc] apiSubtypes = subtypesWithoutShadowing(typ, elemName, api, funSymbRef);
	return { *subtypesWithoutShadowing(s, elemName, client, funSymbRef) | s <- apiSubtypes };
}

set[loc] clientSubtypesWithoutFieldShadowing(loc typ, str signature, M3 api, M3 client) 
	= clientSubtypesWithoutShadowing(typ, signature, api, client, fieldSymbolicRef);
	
set[loc] clientSubtypesWithoutMethShadowing(loc typ, str signature, M3 api, M3 client) 
	= clientSubtypesWithoutShadowing(typ, signature, api, client, methodSymbolicRef);

private set[loc] subtypesElemSymbolic(loc typ, str elemName, M3 m, loc (loc, str) funSymbRef) {
	set[loc] subtypes = subtypesWithoutShadowing(typ, elemName, m, funSymbRef);
	return { funSymbRef(s, elemName) | s <- subtypes };
}

set[loc] subtypesFieldSymbolic(loc typ, str fieldName, M3 m)
	= subtypesElemSymbolic(typ, fieldName, m, fieldSymbolicRef);

set[loc] subtypesMethodSymbolic(loc typ, str signature, M3 m)
	= subtypesElemSymbolic(typ, signature, m, methodSymbolicRef);
	
private set[loc] clientSubtypesElemSymbolic(loc typ, str elemName, M3 api, M3 client, loc (loc, str) funSymbRef) {
	set[loc] apiSubtypes = subtypesWithoutShadowing(typ, elemName, api, funSymbRef);
	set[loc] refs = {};
	
	for (s <- apiSubtypes) {
		set[loc] clientSubtypes = subtypesWithoutShadowing(s, elemName, client, funSymbRef);
		refs += { funSymbRef(c, elemName) | c <- clientSubtypes };
	}
	
	return refs;
}

set[loc] clientSubtypesFieldSymbolic(loc typ, str fieldName, M3 api, M3 client)
	= clientSubtypesElemSymbolic(typ, fieldName, api, client, fieldSymbolicRef);

set[loc] clientSubtypesMethodSymbolic(loc typ, str signature, M3 api, M3 client)
	= clientSubtypesElemSymbolic(typ, signature, api, client, methodSymbolicRef);
	
set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAbstractNowDefault()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return detectionsMethodNowDefault(client, oldAPI, newAPI, modified);
}

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAbstractAddedToClass()) 
	= detectionsMethodAbstractAdded(newAPI, client, delta, ch, extends());
	
set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodAddedToInterface()) 
	= detectionsMethodAbstractAdded(newAPI, client, delta, ch, implements());

private set[Detection] detectionsMethodAbstractAdded(M3 newAPI, M3 client, list[APIEntity] delta, CompatibilityChange ch, APIUse apiUse) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(newAPI, modif);
		
		set[loc] subtypes = subtypesWithoutMethShadowing(parent, signature, newAPI)
			+ subtypesWithoutMethShadowing(parent, signature, client)
			+ clientSubtypesWithoutMethShadowing(parent, signature, newAPI, client)
			+ parent;
		rel[loc, APIUse] affected = affectedEntities(client, apiUse, subtypes);
		
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected, 
			<elem, \abstract()> notin client.modifiers };
	}
	
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodLessAccessible())
	= methodLessAccDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, M3 newAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNewDefault()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return detectionsMethodNowDefault(client, oldAPI, newAPI, modified);
}

private set[Detection] detectionsMethodNowDefault(M3 client, M3 oldAPI, M3 newAPI, set[ChangedEntity] modified) {
	set[Detection] detects = {};
	set[APIUse] apiUses = { methodInvocation(), methodOverride() };
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(newAPI, modif);
		rel[loc, APIUse] affected = {};
		
		set[loc] subtypes = subtypesWithoutMethShadowing(parent, signature, newAPI)
			+ subtypesWithoutMethShadowing(parent, signature, client)
			+ clientSubtypesWithoutMethShadowing(parent, signature, newAPI, client)
			+ parent;
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, newAPI)
			+ subtypesMethodSymbolic(parent, signature, client) 
			+ clientSubtypesMethodSymbolic(parent, signature, newAPI, client) 
			+ modif;
			
		// Check client implements 
		set[loc] affectedClasses = domain(affectedEntities(client, implements(), subtypes));
		
		// Consider the affected class if it has other implemented interfaces
		for (elem <- affectedClasses) {
			set[loc] interfaces = client.implements[elem];
			
			if (<elem, \abstract()> in client.modifiers, size(interfaces) > 1) {
				//Get method declarations
				set[loc] methods = methodDeclarations(client, elem);
				
				// If there is a method override, no problem should be detected
				if (m <- methods, sameMethodSignature(m, modif)) {
					continue;
				}
				
				if (i <- interfaces, hasSameMethod(client, i, modif) 
					|| hasSameMethod(newAPI, i, modif) ) {
					detects += detection(elem, modif, implements(), ch);
				}
			}
			
		}
	}
	
	return detects;
}

private bool hasSameMethod(M3 m, loc typ, loc meth) {
	set[loc] methods = methodDeclarations(m, typ);
	if (e <- methods, sameMethodSignature(e, meth)) {
		return true;
	}
	return false;
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNoLongerStatic()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return detections(client, modified, methodInvocation());
}

private set[Detection] symbTypeDetectionsWithParent(M3 client, M3 oldAPI, set[ChangedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] subtypes = subtypesWithoutMethShadowing(parent, signature, client) 
			+ subtypesWithoutMethShadowing(parent, signature, oldAPI)
			+ clientSubtypesWithoutMethShadowing(parent, signature, oldAPI, client)
			+ parent;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, subtypes) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowAbstract()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return symbTypeDetectionsWithParent(client, oldAPI, modified, { extends(), implements() }) 
		+ symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation() }) ;
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowFinal()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return symbMethodDetections(client, oldAPI, modified, { methodOverride() });
}
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowStatic()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation(), methodOverride() });
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodNowThrowsCheckedException()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation() });
}

		
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodRemoved()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, client) + modif;
		rel[loc, APIUse] affected = domain(rangeR(client.methodInvocation, symbMeths)) * { methodInvocation() }
			+ domain(rangeR(client.methodOverrides, symbMeths)) * { methodOverride() };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected};
	}
	
	return detects + detections(client, oldAPI, modified, methodRemovedInSuperclass()); // Pertaining methodRemovedInSuperclass
}

set[Detection] detections(M3 client, M3 oldAPI, set[ChangedEntity] modified, CompatibilityChange::methodRemovedInSuperclass()) {
	CompatibilityChange change = methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false);
	return detectionsMethodRemovedInSuperclass(client, oldAPI, modified, change);
}

set[Detection] detectionsMethodRemovedInSuperclass(M3 client, M3 oldAPI, set[ChangedEntity] modified, CompatibilityChange ch) {
	set[Detection] detects = {};
	
	for (<modif, _> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		
		// Get modif subtypes and symbolic methods
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, oldAPI)
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client);
		// Get affected client members
		rel[loc, APIUse] affected = domain(rangeR(client.methodInvocation, symbMeths)) * { methodInvocation() }
			+ domain(rangeR(client.methodOverrides, symbMeths)) * { methodOverride() };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::methodReturnTypeChanged()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	return symbMethodDetectionsWithParent(client, oldAPI, modified, { methodInvocation(), methodOverride() });
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::constructorLessAccessible())
	= methodLessAccDetections(client, oldAPI, delta, ch);
	
set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::constructorRemoved()) 
	= methodInvDetections(client, oldAPI, delta, ch);

private set[Detection] methodAllDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, methodOverride())
		+ detections(client, modified, methodInvocation());
}

private set[Detection] methodInvDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, methodInvocation());
}

private set[Detection] methodOverrDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, methodOverride());
}

private set[Detection] methodLessAccDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[APIUse] apiUses = { methodInvocation(), methodOverride() };
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(modif, delta);
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, client) 
			+ subtypesMethodSymbolic(parent, signature, oldAPI)
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client) + modif;
			
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbMeths) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
			!(fromPublicToProtected(access.old, access.new) && hasProtectedAccess(client, oldAPI, elem, modif)), // Public to protected
			!(toPackageProtected(access.new) && samePackage(elem, modif)) }; // To package-private same package
	}
	return detects;
}

private tuple[Modifier, Modifier] getAccessModifiers(loc id, list[APIEntity] delta) {
	set[Modifier] accessModifs = { 
		org::maracas::delta::JApiCmp::\public(), 
		org::maracas::delta::JApiCmp::\protected(), 
		org::maracas::delta::JApiCmp::\packageProtected(), 
		org::maracas::delta::JApiCmp::\private() };
		
	if (/method(id,_,elems,_,_) := delta 
		|| /constructor(id,elems,_,_) := delta
		|| /field(id,_,elems,_,_) := delta
		|| /class(id,_,elems,_,_) := delta) {
		for (e <- elems, /modifier(modified(old, new)) := e, old in accessModifs) {
			return <old, new>;
		}
	}
	throw "There is no reference to <id> in the delta model.";
}

private set[Detection] symbMethodDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change, set[APIUse] apiUses) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return symbMethodDetections(client, oldAPI, modified, apiUses);
}

private set[Detection] symbMethodDetectionsWithParent(M3 client, M3 oldAPI, set[ChangedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, oldAPI) 
			+ subtypesMethodSymbolic(parent, signature, client) 
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client) 
			+ modif;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbMeths) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

private set[Detection] symbMethodDetections(M3 client, M3 oldAPI, set[ChangedEntity] modified, set[APIUse] apiUses) {
	set[Detection] detects = {};
	
	for (<modif, ch> <- modified) {
		str signature = methodSignature(modif);
		loc parent = parentType(oldAPI, modif);
		set[loc] symbMeths = subtypesMethodSymbolic(parent, signature, oldAPI) 
			+ clientSubtypesMethodSymbolic(parent, signature, oldAPI, client) + modif;
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, symbMeths) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, ch) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

private rel[loc, APIUse] affectedEntities(M3 m, APIUse apiUse, set[loc] modified) {
	set[loc] affected = {};
	switch (apiUse) {
	case APIUse::annotation(): affected = domain(rangeR(m.annotations, modified));
	case extends(): affected = domain(rangeR(m.extends, modified));
	case fieldAccess(): affected = domain(rangeR(m.fieldAccess, modified));
	case implements(): affected = domain(rangeR(m.implements, modified));
	case methodInvocation(): affected = domain(rangeR(m.methodInvocation, modified));
	case methodOverride(): affected = domain(rangeR(m.methodOverrides, modified));
	case typeDependency(): affected = domain(rangeR(m.typeDependency, modified));
	default: throw "Wrong APIUse for member type: <apiUse>";
	}
	
	return affected * { apiUse };
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classLessAccessible())
	= detectionsClassLessAccess(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNoLongerPublic())
	= detectionsClassLessAccess(client, oldAPI, delta, ch);


set[Detection] detectionsClassLessAccess(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[APIUse] apiUses = { typeDependency(), extends(), implements(), APIUse::annotation() };
	set[Detection] detects = {};
		
	for (<modif, change> <- modified) {
		tuple[Modifier old, Modifier new] access = getAccessModifiers(modif, delta);
		bool pub2prot = fromPublicToProtected(access.old, access.new);
		bool pkgProt = toPackageProtected(access.new);
		
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, { modif }) | apiUse <- apiUses };
		
		for (<elem, apiUse> <- affected) {
			loc parent = (isType(elem)) ? elem : parentType(client, elem);
			
			if (!(pub2prot && hasProtectedAccess(client, oldAPI, elem, modif)) // Public to protected
			&& !(pkgProt && samePackage(parent, modif))) { // To package-private same package
				
				detects += detection(elem, modif, apiUse, change);
			} 
		}
	}
	return detects;
}

set[Detection] detectionsClassLessAccessOld(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange ch) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
	
		// Let's get the old and new modifiers
		// TODO: consider only access modifiers
		if (/apiClass:class(modif,_,_,_,_) := delta, /modifier(modified(old, new)) := apiClass) {
			rel[loc, APIUse] affected = domain(rangeR(client.typeDependency, {modif})) * { typeDependency() }
				+ domain(rangeR(client.extends, {modif})) * { extends() }
				+ domain(rangeR(client.implements, {modif})) * { implements() }
				+ domain(rangeR(client.annotations, {modif})) * { APIUse::annotation() };
			
			// Include client affected elements that are subtypes of the 
			// modified field parent class, and where modifiers went from
			// public to protected
			detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected,
				!(fromPublicToProtected(old, new) && hasProtectedAccess(client, oldAPI, elem, modif))};
		}
	}
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNowAbstract()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[ChangedEntity] transModified = transitiveConstructors(oldAPI, modified);
	return detections(client, transModified, methodInvocation());
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNowCheckedException()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[APIUse] apiUses = { methodInvocation() };
	set[Detection] detects = {};
	
	for (<modif, change> <- modified) {
		set[loc] clientConstructors = { *constructors(client, s) | s <- clientConcreteSubtypes(modif, oldAPI, client) };
		set[loc] apiConstructors = { *constructors(oldAPI, s) | s <- concreteSubtypes(modif, oldAPI) };
		set[loc] cons = clientConstructors + apiConstructors + constructors(oldAPI, modif);
		
		rel[loc, APIUse] affected = { *affectedEntities(client, apiUse, cons) | apiUse <- apiUses };
		detects += { detection(elem, modif, apiUse, change) | <elem, apiUse> <- affected };
	}
	
	return detects;
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classNowFinal()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[ChangedEntity] transModified = transitiveMethods(oldAPI, modified);
	return detections(client, modified, extends()) 
		+ symbMethodDetections(client, oldAPI, transModified, { methodOverride() });
}

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classRemoved())
	= classAllDetections(client, oldAPI, delta, ch);

set[Detection] detections(M3 client, M3 oldAPI, list[APIEntity] delta, ch:CompatibilityChange::classTypeChanged()) {
	set[ChangedEntity] modified = getChangedEntities(delta, ch);
	set[ChangedEntity] modifExtends = {};
	set[ChangedEntity] modifImplements = {};
	set[ChangedEntity] modifTypeDep = {};
	set[ChangedEntity] modifAnnotation = {};
	
	for (<modif, change> <- modified) {
		APIEntity entity = entityFromLoc(modif, delta);
		tuple[ClassType, ClassType] types = classModifiedType(entity);
		
		switch(types) {
		case <class(), _> :
			modifExtends += <modif, change>;
		case <interface(), _> : {
			modifExtends += <modif, change>;
			modifImplements += <modif, change>;
		}
		case <annotation(), _> :
			modifAnnotation += <modif, change>;
		case <_, annotation()> :
			modifTypeDep += <modif, change>;
		default: ;
		}
	}
	
	return detections(client, modifExtends, extends())
		+ detections(client, modifImplements, implements())
		+ detections(client, modifTypeDep, typeDependency())
		+ detections(client, modifAnnotation, annotation());
}

private set[Detection] classAllDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, extends())
		+ detections(client, modified, implements())
		+ detections(client, modified, typeDependency())
		+ detections(client, modified, APIUse::annotation());
}

private set[Detection] extendsDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, extends());
}

private set[Detection] implementsDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, implements());
}

private set[Detection] typeDependencyDetections(M3 client, M3 oldAPI, list[APIEntity] delta, CompatibilityChange change) {
	set[ChangedEntity] modified = getChangedEntities(delta, change);
	return detections(client, modified, typeDependency());
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
private set[Detection] detections(M3 client, set[ChangedEntity] modified, APIUse apiUse) 
	= { detection(elem, modif, apiUse, ch) | <modif, ch> <- modified, 
		<elem, apiUse> <- affectedEntities(client, apiUse, { modif }) };
		
private set[Detection] detections(M3 client, set[ChangedEntity] modified, set[APIUse] apiUses) 
	= { *detections(client, modified, apiUse) | apiUse <- apiUses };