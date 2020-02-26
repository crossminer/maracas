module org::maracas::delta::JapiCmpUnstable

import org::maracas::delta::JApiCmp;


list[APIEntity] filterUnstableAnnon(list[APIEntity] delta) {
	list[APIEntity] filtered = [];
	
	for (APIEntity e <- delta) {
		visit (e) {
		case class(_, _, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		case field(_, _, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		case method(_, _, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		case constructor(_, _, _, _, _): filtered = addUnstableEntity(e, filtered);
		}
	}
	return filtered;
}

list[APIEntity] addUnstableEntity(APIEntity entity, list[APIEntity] filtered) {
	set[loc] annons = entity.annonStability;
	
	if (annons != {}) {
		filtered += entity;
	}
	return filtered;
}