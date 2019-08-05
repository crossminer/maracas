module org::maracas::delta::DeltaBuilderJapicmp

import org::maracas::delta::Delta;


Delta createDelta(loc from, loc to) {
	return delta(<from, to>);
}