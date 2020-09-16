module org::maracas::\test::delta::japicmp::usage::UnusedChangedEntitiesTest

import Set;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::delta::JApiCmpUsage;


test bool sameAsBefore() 
	= getUnusedChangedEntities(evolBin(), detectsBin()) == getUnusedChangedEntities(evol, detects);

test bool sameSizeAsBefore() 
	= size(getUnusedChangedEntities(evolBin(), detectsBin())) == size(getUnusedChangedEntities(evol, detects));
	
test bool unusedPkgSubset() 
	= unusedPkg() <= getUnusedChangedEntities(evol, detects);

test bool samePerChangeTypeRefCurrent()
	= perChangeType(evol);

test bool samePerChangeTypeRefBin()
	= perChangeType(evolBin());

private bool perChangeType(Evolution ev) {
	set[CompatibilityChange] changes = getCompatibilityChanges(ev.delta);
	for (CompatibilityChange c <- changes) {
		if (getUnusedChangedEntities(evolBin(), detectsBin(), c) != getUnusedChangedEntities(evol, detects, c)) {
			return false;
		}
	}
	return true;
}

test bool sameSizeMap() {
	map[CompatibilityChange, set[loc]] unused = getUnusedChangedEntitiesMap(evol, detects);
	set[loc] entities = { *unused[c] | CompatibilityChange c <- unused };
	return size(entities) == size(getUnusedChangedEntities(evol, detects));
}

test bool mapPerChangeType() {
	map[CompatibilityChange, set[loc]] unused = getUnusedChangedEntitiesMap(evol, detects);
	for (CompatibilityChange c <- unused) {
		if (getUnusedChangedEntities(evol, detects, c) != unused[c]) {
			return false;
		}
	}
	return true;
}