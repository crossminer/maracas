module org::maracas::match::matcher::DeclarationMatcher

import org::maracas::delta::Delta;
import org::maracas::m3::Core;
import org::maracas::m3::M3Diff;


set[Mapping[loc]] levenshteinMatch(M3Diff diff, real threshold) {
	removals = diff.removals;
	additions = diff.additions;
	result = {};
	
	for (<r, declr> <- removals.declarations) {
		for (<a, decla> <- additions.declarations, r.scheme == a.scheme) {
			similarity = levenshteinSimilarity(memberDeclaration(r), memberDeclaration(a));					
			
			if (similarity > threshold) { 
				result += buildMapping(r, a, similarity, MATCH_LEVENSHTEIN);
				continue;
			}
		}
	}
	return result;
}
