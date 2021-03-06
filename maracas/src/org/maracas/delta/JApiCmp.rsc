module org::maracas::delta::JApiCmp

import IO;
import List;
import Node;
import Relation;
import Set;
import String;
import ValueIO;

import lang::java::m3::AST;
import lang::java::m3::Core;

import org::maracas::delta::JApiCmpStability;
import org::maracas::io::properties::IO;


data APIEntity
	= class(
		loc id,
		bool internal,
		set[loc] annonStability,
		EntityType \entType,
		list[APIEntity] entities,
		list[CompatibilityChange] changes,
		APISimpleChange change)
	| interface(
		loc id, 
		list[CompatibilityChange] changes,
		APISimpleChange change) 
	| field(
		loc id, // TODO: is it align with m3 names?
		set[loc] annonStability,
		EntityType \entType,
		list[APIEntity] entities, 
		list[CompatibilityChange] changes,
		APISimpleChange change)
	| method(
		loc id,
		set[loc] annonStability,
		EntityType returnType,
		list[APIEntity] entities,
		list[CompatibilityChange] changes,
		APISimpleChange change)
	| constructor(
		loc id,
		set[loc] annonStability,
		list[APIEntity] entities,
		list[CompatibilityChange] changes,
		APISimpleChange change)
	| annotation(
		loc id,
		list[APIEntity] entities,
		list[CompatibilityChange] changes,
		APISimpleChange change)
	| annotationElement(
		str name, 
		APIChange[list[str]] changeAnn)
	| exception(
		loc id, 
		bool checkedException, 
		APISimpleChange change)
	| parameter(loc \type)
	| modifier(APIChange[Modifier] changeModif)
	| superclass(
		list[CompatibilityChange] changes,
		APIChange[loc] changeSuper)
	| empty()
	;   

data APIChange[&T]
	= new(&T elem)
	| removed(&T elem)
	| unchanged()
	| modified(&T oldElem, &T newElem)
	;
	
data APISimpleChange 
	= new()
	| removed()
	| unchanged()
	| modified()
	;
	
data EntityType 
	= classType(APIChange[ClassType] ctChange)
	| fieldType(APIChange[loc] ftChange)
	| returnType(APIChange[loc] rtChange)
	;
	
data CompatibilityChange(bool binaryCompatibility=false, bool sourceCompatibility=false)
	= annotationDeprecatedAdded()
	| classRemoved()
	| classNowAbstract()
	| classNowFinal()
	| classNoLongerPublic()
	| classTypeChanged()
	| classNowCheckedException()
	| classLessAccessible()
	| superclassRemoved()
	| superclassAdded()
	| superclassModifiedIncompatible()
	| interfaceAdded()
	| interfaceRemoved()
	| methodAbstractAddedInImplementedInterface()
	| methodAbstractAddedInSuperclass()
	| methodAbstractAddedToClass()
	| methodAbstractNowDefault()
	| methodAddedToInterface()
	| methodAddedToPublicClass()
	| methodIsStaticAndOverridesNotStatic()
	| methodLessAccessible()
	| methodLessAccessibleThanInSuperclass()
	| methodMoreAccessible()
	| methodNewDefault()
	| methodNoLongerStatic()
	| methodNoLongerThrowsCheckedException()
	| methodNowAbstract()
	| methodNowFinal()
	| methodNowStatic()
	| methodNowThrowsCheckedException()
	| methodRemoved()
	| methodRemovedInSuperclass()
	| methodReturnTypeChanged()
	| fieldLessAccessible()
	| fieldLessAccessibleThanInSuperclass()
	| fieldMoreAccessible()
	| fieldNoLongerStatic()
	| fieldNowFinal()
	| fieldNowStatic()
	| fieldRemoved()
	| fieldRemovedInSuperclass()
	| fieldStaticAndOverridesStatic()
	| fieldTypeChanged()
	| constructorRemoved()
	| constructorLessAccessible()
	;
	
data ClassType
	= annotation()
	| interface()
	| class()
	| enum()
	;
	
data Modifier
	= packageProtected()
	| nonFinal()
	| nonStatic()
	| nonAbstract()
	| synthetic()
	| nonSynthetic()
	| bridge()
	| nonBridge()
	;
	
alias ChangedEntity 
	= tuple[CompatibilityChange change, loc elem];


//----------------------------------------------
// Core
//----------------------------------------------

@javaClass{org.maracas.delta.internal.JApiCmp}
@reflect{for debugging}
private java list[APIEntity] compareJapi(loc oldJar, loc newJar, str oldVersion, str newVersion, list[loc] oldCP, list[loc] newCP);

list[APIEntity] compareJars(loc oldJar, loc newJar, str oldVersion, str newVersion, list[loc] oldCP = [], list[loc] newCP = []) {
	list[APIEntity] delta = compareJapi(oldJar, newJar, oldVersion, newVersion, oldCP, newCP);
	delta = addInternalFlag(delta);
	delta = addStabilityAnnons(delta, oldJar);
	return delta;
}

list[APIEntity] readBinaryDelta(loc delta)
	= readBinaryValueFile(#list[APIEntity], delta);

@doc {
	Returns a relation mapping API entities that have been
	modified to the type of compatibility change they experienced.
	It consdiers a list of API entities as input (a.k.a. API delta).
	
	@param delta: list of modified APIEntities between two versions 
	       of the target API.
	@return relation mapping modified API entities to compatibility
	        change types (e.g. renamedMethod())
}
@memo
set[ChangedEntity] getChangedEntities(list[APIEntity] delta) 
	= { *getChangedEntities(e) | e <- delta };

set[loc] getChangedEntitiesLoc(list[APIEntity] delta) 
	= range(getChangedEntities(delta));

set[loc] getChangedEntities(list[APIEntity] delta, CompatibilityChange change) 
	= getChangedEntities(delta)[change];
	
@doc {
	Returns a relation mapping API entities that have been
	modified to the type of compatibility change they experienced.
	It only considers one API entity as input.
	
	@param entity: modified API entity between two versions of the 
	       target API.
	@return relation mapping modified API entities to compatibility
	        change types (e.g. renamedMethod())
}
set[ChangedEntity] getChangedEntities(APIEntity entity) {
	set[ChangedEntity] entities = {};
	visit (entity) {
	case class(id, _, _, _, _, changes, _): 
		entities = addChangedEntity(id, changes, entities);
	case interface(id, changes, _):
		entities = addChangedEntity(id, changes, entities);
	case field(id, _, _, _, changes, _): 
		entities = addChangedEntity(id, changes, entities);
	case method(id, _, _, _, changes, _): 
		entities = addChangedEntity(id, changes, entities);
	case constructor(id, _, _, changes, _): 
		entities = addChangedEntity(id, changes, entities);
	}
	return entities;
}

map[CompatibilityChange, set[loc]] getChangedEntitiesMap(list[APIEntity] delta) {
	set[ChangedEntity] changed = getChangedEntities(delta);
	map[CompatibilityChange, set[loc]] changedMap = ();
	
	for (<CompatibilityChange c, loc e> <- changed) {
		changedMap += ( c : (c in changedMap) ? changedMap[c] + e : { e });
	}
	return changedMap;
}

@doc {
	Adds new tuples to a relation mapping API modified entities
	to compatibility change types. These tuples map the element
	location given as parameter to the list of given compatibility 
	changes.
	
	@param element: location to be included in the modElements 
	       relation
	@param modElements: relation mapping modified API entities  
	       to the type of experienced change
	@param changes: list of API change types that should be related
	       to the element location
	@return relation mapping an element location to compatibility
	        change types (e.g. renamedMethod())
}
private set[ChangedEntity] addChangedEntity(loc entity, list[CompatibilityChange] changes, set[ChangedEntity] entities)
	= { <c, entity> | c <- changes } + entities;
	
set[CompatibilityChange] getCompatibilityChanges(APIEntity entity) 
	= { ch | /CompatibilityChange ch := entity };
	
set[CompatibilityChange] getCompatibilityChanges(list[APIEntity] delta)
	= { *getCompatibilityChanges(entity) | entity <- delta };
	

//----------------------------------------------
// Stability
//----------------------------------------------

list[APIEntity] addInternalFlag(list[APIEntity] delta) {
	list[APIEntity] deltaInt = [];
	
	for (APIEntity entity <- delta) {
		if (class(id, _, a, b, c, d, e) := entity && isUnstableAPI(id)) {
			entity = class(id, true, a, b, c, d, e);
		}
		
		deltaInt += entity;
	}
	return deltaInt;
}

list[APIEntity] addStabilityAnnons(list[APIEntity] delta, loc oldJar) {
	M3 apiOld = createM3FromJar(oldJar);
	list[APIEntity] deltaAnnon = [];
	set[loc] annons = {};
	
	for (APIEntity entity <- delta) {
		set[loc] annonsEnt = {};
		APIEntity entityAnnon = top-down visit (entity) {
			case class(id, a, _, b, c, d, e): {
				annonsEnt += fetchStabilityAnnon(id, apiOld, annons);
				insert class(id, a, annonsEnt, b, c, d, e);
			}
			case field(id, _, a, b, c, d): {
				annonsEnt += fetchStabilityAnnon(id, apiOld, annons);
				insert field(id, annonsEnt, a, b, c, d);
			}
			case method(id, _, a, b, c, d): { 
				annonsEnt += fetchStabilityAnnon(id, apiOld, annons);
				insert method(id, annonsEnt, a, b, c, d);
			}
			case constructor(id, _, a, b, c): {
				annonsEnt += fetchStabilityAnnon(id, apiOld, annons);
				insert constructor(id, annonsEnt, a, b, c);
			}
		};
			
		annons += annonsEnt;
		deltaAnnon += entityAnnon;
	}
	
	return deltaAnnon;
}

private set[loc] fetchStabilityAnnon(loc entity, M3 apiOld, set[loc] annons) {
	set[loc] annonsEnt = apiOld.annotations[entity];
	return { ann | loc ann <- annonsEnt, ann in annons || isUnstableAnnon(ann) };
}

list[APIEntity] filterStableAPIByPkg(list[APIEntity] delta) 
	= filterAPIByPkg(delta, bool (bool e) { return !e; });

list[APIEntity] filterUnstableAPIByPkg(list[APIEntity] delta)
	= filterAPIByPkg(delta, bool (bool e) { return e; });

private list[APIEntity] filterAPIByPkg(list[APIEntity] delta, bool(bool) predicate)
	= [ entity | APIEntity entity <- delta, class(_, bool flag, _, _, _, _, _) := entity, predicate(flag) ];
	
list[APIEntity] filterStableAPIByAnnon(list[APIEntity] delta) {
	return top-down visit (delta) {
		case class(_, _, anns, _, _, _, _) => APIEntity::empty() when !isEmpty(anns)
		case field(_, anns, _, _, _, _) => APIEntity::empty() when !isEmpty(anns)
		case method(_, anns, _, _, _, _) => APIEntity::empty() when !isEmpty(anns)
		case constructor(_, anns, _, _, _) => APIEntity::empty() when !isEmpty(anns)
	}
}

list[APIEntity] filterUnstableAPIByAnnon(list[APIEntity] delta) {
	return top-down visit (delta) {
		case c : class(_, _, anns, _, entities, changes, _) : { 
			if (isEmpty(anns)) {
				list[APIEntity] entitiesModif = [];
				
				for (APIEntity e <- entities) {
					if (s : superclass([x, *xs], _) := e) {
						entitiesModif += superclass([], APIChange::unchanged());
					}
					else if (i : interface(id, [x, *xs], _) := e) {
						entitiesModif += interface(id, [], APISimpleChange::unchanged());
					}
					else {
						entitiesModif += e;
					}
				}
				c.changes = [];
				c.entities = entitiesModif;
			}
			insert c;
		} 
		case f : field(_, anns, _, _, _, _) : {
			if (isEmpty(anns)) {
				f.changes = [];
			}
			insert f;
		}
		case m : method(_, anns, _, _, _, _) : {
			if (isEmpty(anns)) {
				m.changes = [];
			}
			insert m;
		}
		case c : constructor(_, anns, _, _, _) : {
			if (isEmpty(anns)) {
				c.changes = [];
			}
			insert c;
		}
	}
}

@memo
set[str] readUnstableKeywords() {
	map[str, str] prop = readProperties(|project://maracas/config/unstable-keywords.properties|);
	list[str] keywords = split(",", replaceAll(prop["keywords"], " ", ""));
	return toSet(keywords);
}

set[loc] getAPIInUnstablePkg(list[APIEntity] delta) {
	set[loc] unstable = {};
	for (c: class(_, true, _, _, _, _, _) <- delta) {
		visit (c) {
		case class(id, _, _, _, _, _, _): unstable += id;
		case field(id, _, _, _, _, _): unstable += id;
		case method(id, _, _, _, _, _): unstable += id;
		case constructor(id, _, _, _, _): unstable += id;
		}
	}
	return unstable;
}

rel[loc, loc] getAPIWithUnstableAnnon(list[APIEntity] delta) {
	rel[loc, loc] unstable = {};	
	visit (delta) {
	case e:class(id, _, anns, _, _, _, _): unstable += { <id, a> | loc a <- anns };
	case e:field(id, anns, _, _, _, _): unstable += { <id, a> | loc a <- anns };
	case e:method(id, anns, _, _, _, _): unstable += { <id, a> | loc a <- anns };
	case e:constructor(id, anns, _, _, _): unstable += { <id, a> | loc a <- anns };
	}
	return unstable;
}

set[loc] getUnstableAnnons(list[APIEntity] delta) {
	rel[loc, loc] unstable = getAPIWithUnstableAnnon(delta);
	return range(unstable);
}

rel[loc, loc] getAPIWithUnstableAnnon(list[APIEntity] delta, set[loc] annons) {
	rel[loc, loc] unstable = getAPIWithUnstableAnnon(delta);
	return rangeR(unstable, annons);
}

	
//----------------------------------------------
// Util
//----------------------------------------------

private list[APIEntity] removeUnchangedEntities(list[APIEntity] apiEntities) {
	list[APIEntity] result = [];
	for (a <- apiEntities) {
		children = getChildren(a);
		
		if (c <- children, unchanged() := c) {
			continue;
		}
		
		result += a;
	}
	return result;
}

list[APIEntity] filterUnchangedEntities(list[APIEntity] apiEntities) {
	list[APIEntity] result = [];
	apiEntities = removeUnchangedEntities(apiEntities);
	
	for (e <- apiEntities) {
		result += visit(e) {
			case class(i, f, a, t, ent, c, s) => class(i, f, a, t, removeUnchangedEntities(ent), c, s)
			case field(i, a, t, ent, c, s) => field(i, a, t, removeUnchangedEntities(ent), c, s)
			case method(i, a, t, ent, c, s) => method(i, a, t, removeUnchangedEntities(ent), c, s)
			case constructor(i, a, ent, c, s) => constructor(i, a, removeUnchangedEntities(ent), c, s)
			case annotation(i, ent, c, s) => annotation(i, removeUnchangedEntities(ent), c, s)
		}
	}
	return result;
}

APIEntity getEntityFromLoc(loc elem, list[APIEntity] delta) {
	switch (delta) {
	case /c:class(elem, _, _, _, _, _, _): 
		return c;
	case /f:field(elem, _, _, _, _, _): 
		return f;
	case /m:method(elem, _, _, _, _, _): 
		return m;
	case /c:constructor(elem, _, _, _, _): 
		return c;
	default:
		throw "No entity in the delta has <elem> as ID.";
	}
}

tuple[ClassType, ClassType] getClassModifiedType(APIEntity c:class(_, _, _, t, _, _, _)) {
	if (/modified(old,new) := t) {
		return <old, new>;
	}
	else {
		throw "The type of the class has not changed.";
	}
}

@memo
rel[loc, tuple[Modifier, Modifier]] getAccessModifiers(list[APIEntity] delta) 
	= { *getAccessModifiers(e) | e <- delta };

rel[loc, tuple[Modifier, Modifier]] getAccessModifiers(APIEntity entity) {
	rel[loc, tuple[Modifier, Modifier]] modifiers = {};
	
	visit (entity) {
	case /class(elem, _, _, _, entities, _, _) : 
		modifiers += createAccessModifiers(elem, entities);
	case /method(elem, _, _, entities, _, _) : 
		modifiers += createAccessModifiers(elem, entities);
	case /constructor(elem, _, entities, _, _) : 
		modifiers += createAccessModifiers(elem, entities);
	case /field(elem, _, _, entities, _, _) : 
		modifiers += createAccessModifiers(elem, entities);
	}
	return modifiers;
}

private rel[loc, tuple[Modifier, Modifier]] createAccessModifiers(loc elem, list[APIEntity] entities) {
	set[Modifier] accessModifs = { 
		\public(), 
		\protected(), 
		\packageProtected(), 
		\private() };
		
	for (APIEntity e <- entities, /modifier(modified(old, new)) := e, old in accessModifs) {
		return { <elem, <old, new>> };
	}
	return {}; // No reference to elem
}

tuple[Modifier, Modifier] getAccessModifiers(loc elem, list[APIEntity] delta) {
	rel[loc, tuple[Modifier, Modifier]] modifiers = getAccessModifiers(delta);	
	if (!isEmpty(modifiers[elem])) {
		return getOneFrom(modifiers[elem]);
	}
	throw "There is no reference to <elem> in the delta model.";
}

rel[loc, loc] getExcepRemovedEntities(list[APIEntity] delta) 
	= { *getExcepEntities(entity, removed(), methodNoLongerThrowsCheckedException()) | APIEntity entity <- delta };

rel[loc, loc] getExcepAddedEntities(list[APIEntity] delta) 
	= { *getExcepEntities(entity, new(), methodNowThrowsCheckedException()) | APIEntity entity <- delta };
	
rel[loc, loc] getExcepEntities(APIEntity entity, APISimpleChange apiCh, CompatibilityChange change) {
	rel[loc, loc] exceptions = {};
	visit(entity) {
	case /method(id, _, _, entities, [*_, change, *_], _):
		for (/exception(excep, true, apiCh) := entities) {
			exceptions += <id, excep>;
		}
	}
	return exceptions;
}

rel[loc, loc] getInterRemovedEntities(list[APIEntity] delta) 
	= { *getInterEntities(entity, removed()) | APIEntity entity <- delta };

rel[loc, loc] getInterAddedEntities(list[APIEntity] delta) 
	= { *getInterEntities(entity, new()) | APIEntity entity <- delta };
	
private rel[loc, loc] getInterEntities(APIEntity entity, APISimpleChange apiCh) {
	rel[loc, loc] interfaces = {};
	visit (entity) {
	case /class(id, _, _, _, entities, _, _): 
		for (/interface(inter, _, apiCh) := entities) {
			interfaces += <id, inter>;
		}
	}
	return interfaces;
}

rel[loc, loc] getSuperRemovedEntities(list[APIEntity] delta) 
	= { *getSuperEntities(entity, true) | APIEntity entity <- delta };

rel[loc, loc] getSuperAddedEntities(list[APIEntity] delta) 
	= { *getSuperEntities(entity, false) | APIEntity entity <- delta };
	
private rel[loc, loc] getSuperEntities(APIEntity entity, bool oldSuper) {
	rel[loc, loc] supers = {};
	visit (entity) {
	case /class(id, _, _, _, entities, _, _): 
		for (/superclass(_, modified(old, new)) := entities) {
			supers += (oldSuper) ? <id, old> : <id, new>;
		}
	}
	return supers;
}

private map[Modifier, int] getModifierLevels() 
	= (	
		\private() : 0,
		packageProtected() : 1,
		protected() : 2,
		\public() : 3 
	);	
	 
bool isLessVisible(Modifier m, Modifier n) {
	map[Modifier, int] level = getModifierLevels();
	return level[m] < level[n];
}

bool isMoreVisible(Modifier m, Modifier n) {
	map[Modifier, int] level = getModifierLevels();
	return level[m] > level[n];
}

bool isPackageProtected(Modifier new) 
	= new == org::maracas::delta::JApiCmp::\packageProtected();
	
bool isChangedFromPublicToProtected(Modifier old, Modifier new) 
	= old == \public() 
	&& new == \protected();
