module org::maracas::m3::Containment

import lang::java::m3::Core;


@memo
rel[loc, loc] getTransContainment(M3 m) = m.containment+;

// TODO: check if these functions can be replaced by the ones offered by M3 Core
private rel[loc, loc] getContainedEntities(M3 m, set[loc] entities, bool (loc) fun) {
	rel[loc, loc] transContain = getTransContainment(m);
	return { <e, c> | loc e <- entities, loc c <- transContain[e], fun(c) };
}


rel[loc, loc] getContainedConstructors(M3 m, set[loc] entities) 
	= getContainedEntities(m, entities, isConstructor);

rel[loc, loc] getContainedMethods(M3 m, set[loc] entities) 
	= getContainedEntities(m, entities, isMethod);

rel[loc, loc] getContainedFields(M3 m, set[loc] entities) 
	= getContainedEntities(m, entities, isField);
	
	
rel[loc, loc] getContainedConstructors(M3 m, loc elem) 
	= getContainedConstructors(m, { elem });

rel[loc, loc] getContainedMethods(M3 m, loc elem) 
	= getContainedMethods(m, { elem });

rel[loc, loc] getContainedFields(M3 m, loc elem) 
	= getContainedFields(m, { elem });