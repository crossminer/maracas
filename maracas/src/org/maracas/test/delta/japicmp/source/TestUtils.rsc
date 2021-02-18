module org::maracas::\test::delta::japicmp::source::TestUtils

import org::maracas::delta::JApiCmpDetector;

bool noDetectionOn(set[Detection] detects, loc l)
	= !any(d <-  detects, d.elem == l);
