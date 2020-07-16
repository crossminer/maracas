module org::maracas::\test::delta::jezek_benchmark::detections::Common

import org::maracas::delta::JApiCmpDetector;
import org::maracas::\test::delta::jezek_benchmark::SetUp;

import String;


bool containsCase(str name) {
	bool has = false;
	for (Detection d <- detects) {
		if (contains(d.elem.path, name)) {
			has = true;
			break;
		}
	}
	return has;
}