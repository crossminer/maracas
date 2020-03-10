module org::maracas::\test::delta::japicmp::usage::UsedNonBreakingEntitiesTest

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::delta::JApiCmpUsage;
import Set;
import ValueIO;


test bool sameAsBefore() 
	= getUsedNonBreakingEntities(evolBin(), detectsBin()) == getUsedNonBreakingEntities(evol, detects);

test bool sameSizeAsBefore() 
	= size(getUsedNonBreakingEntities(evolBin(), detectsBin())) == size(getUsedNonBreakingEntities(evol, detects));

test bool unusedPkgSubset() 
	= !(unusedPkg() <= getUsedNonBreakingEntities(evol, detects));
	
test bool samePerChangeTypeRefCurrent()
	= samePerChangeType(evol);

test bool samePerChangeTypeRefBin()
	= samePerChangeType(evolBin());
	
private bool samePerChangeType(Evolution ev) {
	set[CompatibilityChange] changes = getCompatibilityChanges(ev.delta);
	for (CompatibilityChange c <- changes) {
		if (getUsedNonBreakingEntities(evolBin(), detectsBin(), c) != getUsedNonBreakingEntities(evol, detects, c)) {
			return false;
		}
	}
	return true;
}

test bool sameSizeMap() {
	map[CompatibilityChange, set[loc]] nonbreaking = getUsedNonBreakingEntitiesMap(evol, detects);
	set[loc] entities = { *nonbreaking[c] | CompatibilityChange c <- nonbreaking };
	return size(entities) == size(getUsedNonBreakingEntities(evol, detects));
}

test bool mapPerChangeType() {
	map[CompatibilityChange, set[loc]] nonbreaking = getUsedNonBreakingEntitiesMap(evol, detects);
	for (CompatibilityChange c <- nonbreaking) {
		if (getUsedNonBreakingEntities(evol, detects, c) != nonbreaking[c]) {
			return false;
		}
	}
	return true;
}