module org::maracas::delta::JapiCmpUnstable

import org::maracas::delta::JApiCmp;


list[APIEntity] filterUnstableAnnon(list[APIEntity] delta) {
	list[APIEntity] filtered = [];
	
	for (APIEntity entity <- delta) {
		visit (entity) {
		case e:class(_, _, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		case e:field(_, _, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		case e:method(_, _, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		case e:constructor(_, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		}
	}
	return filtered;
}

private list[APIEntity] addUnstableEntity(APIEntity entity, list[APIEntity] filtered) {
	set[loc] annons = entity.annonStability;
	
	if (annons != {}) {
		filtered += entity;
	}
	return filtered;
}

set[loc] getUnstableAnnons(list[APIEntity] delta) {
	list[APIEntity] filtered = filterUnstableAnnon(delta);
	return { *e.annonStability | APIEntity e <- filtered };
}

list[APIEntity] filterUnstableAnnon(list[APIEntity] delta, set[loc] annons) {
	list[APIEntity] filtered = filterUnstableAnnon(delta);
	return [ *e | APIEntity e <- filtered, e.annonStability & annons != {} ];
}