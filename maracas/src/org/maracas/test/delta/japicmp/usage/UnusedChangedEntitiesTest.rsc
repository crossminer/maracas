module org::maracas::\test::delta::japicmp::usage::UnusedChangedEntitiesTest

import Set;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::delta::JApiCmpUsage;


test bool sameAsBefore() 
	= getUnusedChangedEntities(evolBin()) == getUnusedChangedEntities(evol);

test bool sameSizeAsBefore() 
	= size(getUnusedChangedEntities(evolBin())) == size(getUnusedChangedEntities(evol));
	
test bool unusedPkgSubset() 
	= unusedPkg() <= getUnusedChangedEntities(evol);

set[loc] dif() = unusedPkg() - getUnusedChangedEntities(evol);

set[loc] a() = getUnusedChangedEntities(evol);

test bool samePerChangeTypeRefCurrent()
	= perChangeType(evol);

test bool samePerChangeTypeRefBin()
	= perChangeType(evolBin());

private bool perChangeType(Evolution ev) {
	set[CompatibilityChange] changes = getCompatibilityChanges(ev.delta);
	for (CompatibilityChange c <- changes) {
		if (getUnusedChangedEntities(evolBin(), c) != getUnusedChangedEntities(evol, c)) {
			return false;
		}
	}
	return true;
}

test bool sameSizeMap() {
	map[CompatibilityChange, set[loc]] unused = getUnusedChangedEntitiesMap(evol);
	set[loc] entities = { *unused[c] | CompatibilityChange c <- unused };
	return size(entities) == size(getUnusedChangedEntities(evol));
}

test bool mapPerChangeType() {
	map[CompatibilityChange, set[loc]] unused = getUnusedChangedEntitiesMap(evol);
	for (CompatibilityChange c <- unused) {
		if (getUnusedChangedEntities(evol, c) != unused[c]) {
			return false;
		}
	}
	return true;
}