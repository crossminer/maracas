module org::maracas::\test::delta::japicmp::usage::Common

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import ValueIO;


@memo
set[Detection] detectsBin() = readBinaryValueFile(#set[Detection], detectsLoc);

@memo
Evolution evolBin() = readBinaryValueFile(#Evolution, evolLoc);

@memo
set[loc] unusedPkg() {
	set[loc] unusedDetect = transformDetectToUnused();
	set[loc] unusedDelta = transformDeltaToUnused();
	return unusedDetect & unusedDelta;
}

private set[loc] transformDetectToUnused()
	= { transformToUnused(d.src) | Detection d <- detects };

private set[loc] transformDeltaToUnused() {
	set[loc] entities = getChangedEntitiesLoc(delta);
	return { transformToUnused(e) | loc e <- entities };
}

private loc transformToUnused(loc l) {
	l.path = visit(l.path) {
		case /\/main\/<n:[A-za-z0-1$\/]+>/ => "/main/unused/<n>"
	}
	l.path = visit(l.path) {
		case /main[.]<n:[A-za-z0-1$.]+>/ => "main.unused.<n>"
	}
	return l;
}