module org::maracas::\test::delta::japicmp::unstable::UnstableAnnonTest

import List;
import Set;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JapiCmpUnstable;


test bool numberUnstableDecl() 
	= size(filterUnstableAnnon(delta)) == 6;
	
test bool unstableAnnons()
	= { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| }
	== getUnstableAnnons(delta); 

test bool betaAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/Beta| };
	return numberAnnonEntities(annons, 3);
}

test bool isUnstAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/IsUnstable| };
	return numberAnnonEntities(annons, 3);
}

test bool betaAnnonEntities() {
	set[loc] annons = { |java+interface:///main/unstableAnnon/Beta|,
		|java+interface:///main/unstableAnnon/IsUnstable| };
	return numberAnnonEntities(annons, 6);
}

private bool numberAnnonEntities(set[loc] annons, int number)
	= size(filterUnstableAnnon(delta, annons)) == number;