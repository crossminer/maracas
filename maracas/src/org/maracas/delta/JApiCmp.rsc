module org::maracas::delta::JApiCmp

import IO;
import lang::java::m3::AST;
import lang::java::m3::Core;
import List;
import Node;
import Relation;
import Set;
import String;
import ValueIO;

import org::maracas::delta::JapiCmpUnstable;
import org::maracas::io::properties::IO;


data APIEntity
	= class(
		loc id,
		set[loc] annonStability,
		EntityType \entType,
		list[APIEntity] entities,
		list[CompatibilityChange] changes,
		APISimpleChange change)
	| interface(
		loc id, 
		set[CompatibilityChange] changes2,
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
		APIChange[list[str]] change4)
	| exception(
		loc id, 
		bool checkedException, 
		APISimpleChange change)
	| parameter(loc \type)
	| modifier(APIChange[Modifier] changeModif)
	| superclass(
		list[CompatibilityChange] changes,
		APIChange[loc] changeSuper)
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

@javaClass{org.maracas.delta.internal.JApiCmp}
@reflect{for debugging}
private java list[APIEntity] compareJapi(loc oldJar, loc newJar, str oldVersion, str newVersion, list[loc] oldCP, list[loc] newCP);

list[APIEntity] compareJars(loc oldJar, loc newJar, str oldVersion, str newVersion, list[loc] oldCP = [], list[loc] newCP = []) {
	list[APIEntity] delta = compareJapi(oldJar, newJar, oldVersion, newVersion, oldCP, newCP);
	delta = addStabilityAnnons(delta, oldJar);
	return delta;
}

list[APIEntity] addStabilityAnnons(list[APIEntity] delta, loc oldJar) {
	M3 apiOld = createM3FromJar(oldJar);
	list[APIEntity] deltaAnnon = [];
	set[loc] annons = {};
	
	for (APIEntity entity <- delta) {
		set[loc] annonsEnt = {};
		APIEntity entityAnnon = top-down visit (entity) {
			case class(id, _, a, b, c, d): {
				annonsEnt += fetchStabilityAnnon(id, apiOld, annons);
				insert class(id, annonsEnt, a, b, c, d);
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

set[loc] fetchStabilityAnnon(loc entity, M3 apiOld, set[loc] annons) {
	set[loc] annonsEnt = apiOld.annotations[entity];
	return { ann | loc ann <- annonsEnt, ann in annons || containsUnstableKeyword(ann) };
}

private bool containsUnstableKeyword(loc annon) {
	set[str] keywords = readUnstableKeywords();
	str annonPath = toLowerCase(annon.path);
	
	if (str k <- keywords, contains(annonPath, k)) {
		return true;
	}
	return false;
}

@memo
set[str] readUnstableKeywords() {
	map[str, str] prop = readProperties(|project://maracas/config/unstable-keywords.properties|);
	list[str] keywords = split(",", replaceAll(prop["keywords"], " ", ""));
	return toSet(keywords);
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
	case class(id, _, _, _, changes, _): 
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
	
private list[APIEntity] removeUnchangedEntities(list[APIEntity] apiEntities) {
	list[APIEntity] result = [];
	for (a <- apiEntities) {
		children = getChildren(a);
		
		if (c <- children, APIEntity::unchanged() := c) {
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
			case class(i, _, t, ent, c, s) => class(i, t, removeUnchangedEntities(ent), c, s)
			case field(i, _, t, ent, c, s) => field(i, t, removeUnchangedEntities(ent), c, s)
			case method(i, _, t, ent, c, s) => method(i, t, removeUnchangedEntities(ent), c, s)
			case constructor(i, _, ent, c, s) => constructor(i, removeUnchangedEntities(ent), c, s)
			case annotation(i, ent, c, s) => annotation(i, removeUnchangedEntities(ent), c, s)
		}
	}
	return result;
}

APIEntity entityFromLoc(loc elem, list[APIEntity] delta) {
	switch (delta) {
	case /c:class(elem, _, _, _, _, _): 
		return c;
	case /i:interface(elem, chs, _):
		return i;
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

tuple[ClassType, ClassType] classModifiedType(APIEntity c:class(_, _, t, _, _, _)) {
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
	case /class(elem, _, _, entities, _, _) : 
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
		org::maracas::delta::JApiCmp::\public(), 
		org::maracas::delta::JApiCmp::\protected(), 
		org::maracas::delta::JApiCmp::\packageProtected(), 
		org::maracas::delta::JApiCmp::\private() };
		
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

rel[loc, loc] getInterRemovedEntities(list[APIEntity] delta) 
	= { *getInterEntities(entity, removed()) | APIEntity entity <- delta };

rel[loc, loc] getInterAddedEntities(list[APIEntity] delta) 
	= { *getInterEntities(entity, new()) | APIEntity entity <- delta };
	
private rel[loc, loc] getInterEntities(APIEntity entity, APISimpleChange apiCh) {
	rel[loc, loc] interfaces = {};
	visit (entity) {
	case /class(id, _, _, entities, _, _): 
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
	case /class(id, _, _, entities, _, _): 
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
		protected() : 2,
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
	= old == org::maracas::delta::JApiCmp::\public() 
	&& new == org::maracas::delta::JApiCmp::\protected();