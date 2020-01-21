module org::maracas::\test::delta::japicmp::usage::UnusedChangedEntitiesTest

import IO;
import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::delta::JApiCmpUsage;
import Set;


bool unusedPkg() {
	set[loc] unused = {};
	for (Detection d <- detects) {		
		loc e = d.used;
		
		e.path = visit(e.path) {
			case /\/main\/<n:[A-za-z0-1$\/]+>/ => "/main/unused/<n>"
		}
		unused += e;
	}
	
	println(size(unused));
	println(size(getUnusedChangedEntities(m3Client, delta)));
	
	iprintln(unused - getUnusedChangedEntities(m3Client, delta));
	
	return unused <= getUnusedChangedEntities(m3Client, delta);
}