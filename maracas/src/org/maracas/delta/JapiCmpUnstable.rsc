module org::maracas::delta::JapiCmpUnstable

import Set;

import org::maracas::delta::JApiCmp;


list[APIEntity] filterStableAPI(list[APIEntity] delta) {
	return visit (delta) {
		case e:class(_, _, anns, _, _, _, _) => APIEntity::empty() when !isEmpty(anns)
		case e:field(_, anns, _, _, _, _) => APIEntity::empty() when !isEmpty(anns)
		case e:method(_, anns, _, _, _, _) => APIEntity::empty() when !isEmpty(anns)
		case e:constructor(_, anns, _, _, _) => APIEntity::empty() when !isEmpty(anns)
	}
}

set[loc] getUnstableAnnons(list[APIEntity] delta) {
	list[APIEntity] filtered = filterUnstableAnnon(delta);
	return { *e.annonStability | APIEntity e <- filtered };
}

list[APIEntity] filterUnstableAnnon(list[APIEntity] delta, set[loc] annons) {
	list[APIEntity] filtered = filterUnstableAnnon(delta);
	return [ *e | APIEntity e <- filtered, e.annonStability & annons != {} ];
}

list[APIEntity] filterStableAPIByName(list[APIEntity] delta) 
	= [ entity | APIEntity entity <- delta, class(_, flag, _, _, _, _, _) := entity, !flag ];