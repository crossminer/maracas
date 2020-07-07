module org::maracas::\test::delta::japicmp::unstable::UnstableAnnonTest

import List;
import Relation;
import Set;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;


test bool numberUnstableDecls() 
	= size(domain(getAPIWithUnstableAnnon(delta))) == 20;

int f() = size(domain(getAPIWithUnstableAnnon(delta)));
test bool unstableAnnonsDelta()
	= { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| }
	== getUnstableAnnons(delta); 

test bool betaAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/Beta| };
	return numberAnnonEntities(annons, 12);
}

test bool isUnstAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/IsUnstable| };
	return numberAnnonEntities(annons, 8);
}

test bool betaAnnonEntitiesAll() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| };
	return numberAnnonEntities(annons, 20);
}

private bool numberAnnonEntities(set[loc] annons, int number)
	= size(domain(getAPIWithUnstableAnnon(delta, annons))) == number;
	
test bool allHaveUnstAnnons() {
	set[Detection] unstable = filterUnstableDetectsByAnnon(delta, detects);
	for (Detection d <- unstable) {
		APIEntity entity = getEntityFromLoc(d.src, delta);
		if (entity.annonStability == {}) {
			return false;
		}
	}
	return true;
}

test bool allHaveBetaAnnon()
	= allHaveGivenAnnons({ |java+interface:///main/unstableAnnon/Beta| });

test bool allHaveIsUnstAnnon()
	= allHaveGivenAnnons({ |java+interface:///main/unstableAnnon/IsUnstable| });

private bool allHaveGivenAnnons(set[loc] annons) 
	= allDetectsHaveGivenAnnons(filterUnstableDetectsByAnnon(delta, detects, annons), annons);
	
private bool allDetectsHaveGivenAnnons(set[Detection] unstable, set[loc] annons) {
	for (Detection d <- unstable) {
		APIEntity entity = getEntityFromLoc(d.src, delta);
		bool hasAnnon = false;
		
		for (loc a <- annons) {
			if (a in entity.annonStability) {
				hasAnnon = true;
				break;
			}
		}
		
		if (!hasAnnon) {
			return false;
		}
	}
	return true;
}

test bool betaAndIsUnstSetsDiffer() {
	set[Detection] beta = filterUnstableDetectsByAnnon(delta, detects, { |java+interface:///main/unstableAnnon/Beta| });
	set[Detection] isUnst = filterUnstableDetectsByAnnon(delta, detects, { |java+interface:///main/unstableAnnon/IsUnstable| });
	return beta != isUnst;
}

test bool sameSetsAllAnnons() {
	set[loc] annons = { 
		|java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| 
	};
		
	return filterUnstableDetectsByAnnon(delta, detects, annons)
		== filterUnstableDetectsByAnnon(delta, detects);
}

test bool sameDetects()
	 = range(getDetectsWithUnstableAnnon(delta, detects))
	 == filterUnstableDetectsByAnnon(delta, detects);

test bool allInRelHaveBetaAnnon()
	= allInRelHaveGivenAnnons({ |java+interface:///main/unstableAnnon/Beta| });

test bool allInRelHaveIsUnstAnnon()
	= allInRelHaveGivenAnnons({ |java+interface:///main/unstableAnnon/IsUnstable| });
		
private bool allInRelHaveGivenAnnons(set[loc] annons)
	= allDetectsHaveGivenAnnons(range(getDetectsWithUnstableAnnon(delta, detects, annons)), annons);

test bool sameDetectsBetaAnnon()
	= sameDetectsGivenAnnon({ |java+interface:///main/unstableAnnon/Beta| });
	
test bool sameDetectsIsUnstAnnon()
	= sameDetectsGivenAnnon({ |java+interface:///main/unstableAnnon/IsUnstable| });

test bool sameDetectsAllAnnons() {
	set[loc] annons = { 
		|java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| 
	};
	return sameDetectsGivenAnnon(annons);
}
		
private bool sameDetectsGivenAnnon(set[loc] annons)
	= range(getDetectsWithUnstableAnnon(delta, detects, annons))
	== filterUnstableDetectsByAnnon(delta, detects, annons);
	
test bool unstableAnnonsInRel()
	= { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| }
	== domain(getDetectsWithUnstableAnnon(delta, detects));
	
test bool unstableAnnonsDetects()
	= { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| }
	== getUnstableAnnons(delta, detects); 