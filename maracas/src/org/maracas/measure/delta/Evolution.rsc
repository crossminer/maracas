module org::maracas::measure::delta::Evolution

import IO;
import List;
import org::maracas::delta::JApiCmp;


int numberChanges(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + 1 | /CompatibilityChange ch := entity);
	}
	return count;
}

int numberChangesPerType(list[APIEntity] delta, CompatibilityChange ch) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + 1 | /ch := entity);
	}
	return count;
}

map[CompatibilityChange, int] numberChangesPerType(list[APIEntity] delta) {
	set[CompatibilityChange] changes = compatibilityChanges(delta);
	return ( ch : numberChangesPerType(delta, ch) | ch <- changes );
}

int numberChangedTypes(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + 1 | /class(_,_,_,chs,_) := entity, chs != []);
	}
	return count;
}

int numberChangedMethod(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + 1 | /method(_,_,_,chs,_) := entity, chs != []);
		count += (0 | it + 1 | /constructor(_,_,chs,_) := entity, chs != []);
	}
	return count;
}

int numberChangedField(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + 1 | /field(_,_,_,chs,_) := entity, chs != []);
	}
	return count;
}

map[str, int] numberChangedEntities(list[APIEntity] delta) 
	= (
		"Type" : numberChangedTypes(delta),
		"Method" : numberChangedMethod(delta),
		"Field" : numberChangedField(delta)
	);

int numberTypeChanges(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + size(chs) | /class(_,_,_,chs,_) := entity, chs != []);
	}
	return count;
}

int numberMethodChanges(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + size(chs) | /method(_,_,_,chs,_) := entity, chs != []);
		count += (0 | it + size(chs) | /constructor(_,_,chs,_) := entity, chs != []);
	}
	return count;
}

int numberFieldChanges(list[APIEntity] delta) {
	int count = 0;
	for (entity <- delta) {
		count += (0 | it + size(chs) | /field(_,_,_,chs,_) := entity, chs != []);
	}
	return count;
}