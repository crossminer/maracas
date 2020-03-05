module org::maracas::\test::delta::japicmp::unstable::UnstableAnnonTest

import List;
import Relation;
import Set;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;


test bool numberUnstableDecl() 
	= size(domain(getAPIWithUnstableAnnon(delta))) == 10;
	
test bool unstableAnnons()
	= { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| }
	== getUnstableAnnons(delta); 

test bool betaAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/Beta| };
	return numberAnnonEntities(annons, 6);
}

test bool isUnstAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/IsUnstable| };
	return numberAnnonEntities(annons, 4);
}

test bool betaAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| };
	return numberAnnonEntities(annons, 10);
}

private bool numberAnnonEntities(set[loc] annons, int number)
	= size(domain(getAPIWithUnstableAnnon(delta, annons))) == number;