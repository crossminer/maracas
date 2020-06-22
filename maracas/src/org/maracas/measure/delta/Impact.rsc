module org::maracas::measure::delta::Impact

import Node;
import Set;
import lang::java::m3::Core;

import org::maracas::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;


int numberDetections(set[Detection] detects) 
	= size(detects);
	
int numberDetectionsPerType(set[Detection] detects, CompatibilityChange ch)
	= ( 0 | it + 1 | Detection d <- detects, d.change == ch );
	
map[CompatibilityChange, int] numberDetectionsPerType(set[Detection] detects)
	= (ch : numberDetectionsPerType(detects, ch) | ch <- getCompatibilityChanges(detects));

int numberImpactedTypes(set[Detection] detects)
	= ( 0 | it + 1 | Detection d <- detects, isType(d.elem) );

int numberImpactedMethods(set[Detection] detects)	
	= ( 0 | it + 1 | Detection d <- detects, isMethod(d.elem) );
	
int numberImpactedFields(set[Detection] detects)	
	= ( 0 | it + 1 | Detection d <- detects, isField(d.elem) );
	
map[str, int] numberImpactedEntities(set[Detection] detects) 
	= (
		"Type"   : numberImpactedTypes(detects),
		"Method" : numberImpactedMethods(detects),
		"Field"  : numberImpactedFields(detects)
	);
	
map[str, value] detectionsStats(set[Detection] detects) {
	map[CompatibilityChange, int] dts = numberDetectionsPerType(detects);
	map[str, value] stats = ( getName(c) : dts[c] | c <- dts );

	stats["detects"]          = detects;
	stats["numDetects"]       = numberDetections(detects);
	stats["impactedTypes"]    = numberImpactedTypes(detects);
	stats["impactedMethods"]  = numberImpactedMethods(detects);
	stats["impactedFields"]   = numberImpactedFields(detects);

	return stats;
}