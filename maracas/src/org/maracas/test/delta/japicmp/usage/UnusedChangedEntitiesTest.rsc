module org::maracas::\test::delta::japicmp::usage::UnusedChangedEntitiesTest

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::delta::JApiCmpUsage;
import Set;


test bool sameAsBefore() 
	= getUnusedChangedEntities(evolBin()) == getUnusedChangedEntities(evol);

test bool sameSizeAsBefore() 
	= size(getUnusedChangedEntities(evolBin())) == size(getUnusedChangedEntities(evol));
	
test bool unusedPkgSubset() 
	= unusedPkg() <= getUnusedChangedEntities(evol);

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
