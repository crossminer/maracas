 module org::maracas::\test::delta::japicmp::usage::UsedBreakingEntitiesTest

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::delta::JApiCmpUsage;
import Set;
import ValueIO;


test bool sameAsBefore() 
	= getUsedBreakingEntities(detectsBin()) == getUsedBreakingEntities(detects);

test bool sameSizeAsBefore() 
	= size(getUsedBreakingEntities(detectsBin())) == size(getUsedBreakingEntities(detects));

test bool unusedPkgSubset() 
	= !(unusedPkg() <= getUsedBreakingEntities(detects));
	
test bool samePerChangeTypeRefCurrent()
	= samePerChangeType(evol);

test bool samePerChangeTypeRefBin()
	= samePerChangeType(evolBin());
	
private bool samePerChangeType(Evolution ev) {
	set[CompatibilityChange] changes = getCompatibilityChanges(ev.delta);
	for (CompatibilityChange c <- changes) {
		if (getUsedBreakingEntities(detectsBin(), c) != getUsedBreakingEntities(detects, c)) {
			return false;
		}
	}
	return true;
}

test bool sameSizeMap() {
	map[CompatibilityChange, set[loc]] breaking = getUsedBreakingEntitiesMap(detects);
	set[loc] entities = { *breaking[c] | CompatibilityChange c <- breaking };
	return size(entities) == size(getUsedBreakingEntities(detects));
}

test bool mapPerChangeType() {
	map[CompatibilityChange, set[loc]] breaking = getUsedBreakingEntitiesMap(detects);
	for (CompatibilityChange c <- breaking) {
		if (getUsedBreakingEntities(detects, c) != breaking[c]) {
			return false;
		}
	}
	return true;
}