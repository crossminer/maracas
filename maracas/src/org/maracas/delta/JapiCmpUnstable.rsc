module org::maracas::delta::JapiCmpUnstable

import org::maracas::delta::JApiCmp;


list[APIEntity] filterUnstableAnnon(list[APIEntity] delta) {
	list[APIEntity] filtered = [];
	
	for (APIEntity entity <- delta) {		
		visit (entity) {
		case e:class(_, set[loc] a, _, _, _, _): filtered += (a != {}) ? e : [];
		case e:field(_, set[loc] a, _, _, _, _): filtered += (a != {}) ? e : [];
		case e:method(_, set[loc] a, _, _, _, _): filtered += (a != {}) ? e : [];
		case e:constructor(_, set[loc] a, _, _, _): filtered += (a != {}) ? e : [];
		}
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