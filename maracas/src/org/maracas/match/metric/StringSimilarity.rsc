module org::maracas::match::metric::StringSimilarity

import lang::java::m3::Core;
import org::maracas::config::Options;
import org::maracas::delta::Delta;
import org::maracas::m3::M3Diff;


set[Mapping[loc]] levenshteinMatch(M3Diff diff, real threshold, str (loc, M3) createSnippet) {
	M3 removals = diff.removals;
	M3 additions = diff.additions;
	result = {};
	
	for (<r, _> <- removals.declarations) {
		for (<a, _> <- additions.declarations, r.scheme == a.scheme) {
			str snippet1 = createSnippet(r, diff.from); 
			str snippet2 = createSnippet(a, diff.to);			
			real similarity = levenshteinSimilarity(snippet1, snippet2);
								
			if (similarity > threshold) { 
				result += buildMapping(r, a, similarity, MATCH_LEVENSHTEIN);
				continue;
			}
		}
	}
	return result;
}

@javaClass{org.maracas.match.metric.internal.StringSimilarity}
@reflect{for debugging}
private java real levenshteinSimilarity(str snippet1, str snippet2);