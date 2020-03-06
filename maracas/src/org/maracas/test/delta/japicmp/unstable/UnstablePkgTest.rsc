module org::maracas::\test::delta::japicmp::unstable::UnstablePkgTest

import List;
import String;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::m3::Core;


test bool numberUnstableDecls()
	= size(delta - filterStableAPIByName(delta)) == 14;

test bool expectedPkgs() {
	set[loc] changed = getChangedEntitiesLoc(delta - filterStableAPIByName(delta));
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