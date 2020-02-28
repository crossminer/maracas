module org::maracas::\test::delta::japicmp::delta::JApiCmpDeltaTest

import List;
import Map;

import org::maracas::delta::JApiCmp;
import org::maracas::\test::delta::japicmp::delta::JApiCmpResults;
import org::maracas::\test::delta::japicmp::SetUp;


map[str, list[str]] changesJapi = getChangesPerClassJApi(apiOld.path, apiNew.path);
map[str, list[str]] changesMaracas = getChangesPerClassMaracas(delta);
	
test bool numberChangedClasses()
	= getNumClasses(apiOld.path, apiNew.path) == size(delta);

test bool sameNumberClasses()
	= size(changesJapi) == size(changesMaracas);

test bool sameClasses()
	= domain(changesJapi) == domain(changesMaracas);
	
test bool sameChangesClasses() {
	for (str k <- changesJapi) {
		if (changesMaracas[k] != changesJapi[k]) {
			throw "Class <k> has different changes in JApiCmp and maracas: \n"
				+ "JApiCmp: <changesJapi[k]> \n Maracas: <changesMaracas[k]>";
		}
	}
	return true;
}