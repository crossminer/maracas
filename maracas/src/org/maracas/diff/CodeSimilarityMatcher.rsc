module org::maracas::diff::CodeSimilarityMatcher

import IO;
import lang::java::m3::Core;
import List;
import org::maracas::bc::BreakingChanges;
import org::maracas::config::Options;
import Set;


set[Mapping[loc]] levenshteinMatch(M3 additions, M3 removals, bool (loc) fun) {
	simThreshold = 0.7;// FIXME: to be tuned
	result = {};
	
	for (<cont, r> <- removals.containment, fun(r) && include(r)) {
		for (a <- additions.containment[cont], fun(a) && include(a)) {
			snippet1 = ""; 
			snippet2 = "";
			
			if (additions.id.extension == "jar") {
				// Considering contained declaration locs
				// Warning: we don't take into account declarations ordering 
				snippet1 = toString(sort(removals.containment[r]));
				snippet2 = toString(sort(additions.containment[a]));
			}
			else {
				snippet1 = readFile(getFirstFrom(removals.declarations[r]));
				snippet2 = readFile(getFirstFrom(additions.declarations[a]));
			}
			
			similarity = levenshteinSimilarity(snippet1, snippet2);	
			if (similarity > simThreshold) { 
				result += <r, a, similarity, MATCH_LEVENSHTEIN>;
				continue;
			}
		}
	}
	return result;
}


set[Mapping[loc]] jaccardMatch(M3 additions, M3 removals, bool (loc) fun) {
	simThreshold = 0.7;// FIXME: to be tuned
	result = {};
	
	for (<cont, r> <- removals.containment, fun(r) && include(r)) {
		for (a <- additions.containment[cont], fun(a) && include(a)) {
			set[loc] d = {};
			set[loc] e = {};

			if (isClass(r)) {
				for (methodDecl <- removals.containment[r]) {
					d += removals.methodInvocation[methodDecl];
				}
				for (methodDecl <- additions.containment[a]) {
					e += additions.methodInvocation[methodDecl];
				}
			} 
			else if (isMethod(r)) {
				d += removals.methodInvocation[r];
				e += additions.methodInvocation[a];
			} 
			else if (isField(r)) {
				//println("Skipping field");
			};
			
			if (size(d) > 0 && size(e) > 0) {
				real score = jaccard(d, e);

				// Hard assumption: Assuming that the first match is the right one
				if (score > simThreshold) {
					result += <r, a, score, MATCH_JACCARD>;
					continue;
				}
			}
		}
	}
	
	return result;
}


@javaClass{org.maracas.diff.internal.CodeSimilarity}
@reflect{for debugging}
java real levenshteinSimilarity(str snippet1, str snippet2);

// FIXME: copied from BreakingChangesBuilder 
private bool include(loc l) {
	return /org\/sonar\/api\/internal\// !:= l.uri;
}