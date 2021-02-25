module org::maracas::\test::delta::japicmp::source::detections::CoreTest

import Map;
import Set;

import org::maracas::\test::delta::japicmp::source::SetUp;
import org::maracas::\test::delta::japicmp::source::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;


test bool sameDetects() {
	map[CompatibilityChange, set[Detection]] changes = getDetectionsByChange(detects);
	return ( 0 | it + size(changes[k]) | CompatibilityChange k <- domain(changes) )
		== size(detects); 
}

test bool correctDetectsMap() {
	map[CompatibilityChange, set[Detection]] changes = getDetectionsByChange(detects);
	for (CompatibilityChange k <- domain(changes)) {
		for (Detection d <- changes[k]) {
			if (d.change != k) {
				return false;
			}
		}
	}
	return true;
}