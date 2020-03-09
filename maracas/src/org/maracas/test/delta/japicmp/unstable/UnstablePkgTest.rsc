module org::maracas::\test::delta::japicmp::unstable::UnstablePkgTest

import List;
import Set;
import String;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;


test bool numberUnstableEntities()
	= size(filterUnstableAPIByPkg(delta)) == 14;

test bool numberUnstableDecls()
	= size(getAPIInUnstablePkg(delta)) == 30;

test bool expectedPkgsEntities() {
	set[loc] changed = getChangedEntitiesLoc(filterUnstableAPIByPkg(delta));
	return expectedPkgs(changed);
}

test bool expectedPkgsDecls() {
	set[loc] changed = getAPIInUnstablePkg(delta);
	return expectedPkgs(changed);
}

private bool expectedPkgs(set[loc] changed) {
	set[str] pkgs = { packag(c) | loc c <- changed };
	set[str] pkgsExp = { "/main/unstableAnnon/", "/main/unstablePkg/" };
	
	for (str p <- pkgs) {
		if (isEmpty(p)) {
			continue;
		}
		
		bool isChild = false;
		for (str e <- pkgsExp) {
			if (startsWith(p, e)) {
				isChild = true;
				break;
			}
		}
		
		if (!isChild) {
			return false;
		}
	}
	return true;
}