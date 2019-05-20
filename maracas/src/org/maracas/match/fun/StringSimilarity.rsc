module org::maracas::match::fun::StringSimilarity

import lang::java::m3::Core;
import org::maracas::config::Options;
import org::maracas::delta::Delta;
import org::maracas::m3::Core;
import org::maracas::m3::M3Diff;
import org::maracas::match::struc::Data;
import Relation;


set[Mapping[loc]] levenshteinMatch(M3Diff diff, Data dat) {
	remDeclarations = getUniqueDomain(diff.removals.declarations, diff.additions.declarations);
	addDeclarations = getUniqueDomain(diff.additions.declarations, diff.removals.declarations);
	real threshold = dat.threshold;
	result = {};
	
	for (loc r <- remDeclarations, isTargetMember(r)) {
		for (loc a <- addDeclarations, r.scheme == a.scheme) {	
			real similarity = levenshteinSimilarity(dat.from[r], dat.to[a]);
								
			if (similarity > threshold) { 
				result += buildMapping(r, a, similarity, MATCH_LEVENSHTEIN);
				continue;
			}
		}
	}
	return result;
}

@javaClass{org.maracas.match.fun.internal.StringSimilarity}
@reflect{for debugging}
private java real levenshteinSimilarity(str snippet1, str snippet2);