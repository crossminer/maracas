module org::maracas::match::matcher::SnippetMatcher

import IO;
import List;
import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::config::Options;
import org::maracas::m3::Core;
import org::maracas::m3::M3Diff;
import org::maracas::match::metric::StringSimilarity;
import Set;


set[Mapping[loc]] levenshteinSnippetMatch(M3Diff diff, real threshold) 
	= levenshteinMatch(diff, threshold, createSnippet);

str createSnippet(loc elem, M3 owner)
	= (owner.id.extension == "jar") 
	? createSnippetForJar(elem, owner)
	: createSnippetForSourceCode(elem, owner);

// We don't take into account declarations ordering 
private str createSnippetForJar(loc elem, M3 owner) 
	= memberDeclaration(elem, owner)
	+ toString(sort(owner.containment[elem]))
	+ toString(sort(owner.methodInvocation[elem]))
	+ toString(sort(owner.fieldAccess[elem]));
	
private str createSnippetForSourceCode(loc elem, M3 owner) 
	= readFile(getOneFrom(owner.declarations[elem]));
	
	
set[Mapping[loc]] jaccardMatch(M3Diff diff, real threshold) {
	removals = diff.removals;
	additions = diff.additions;
	result = {};

	for (<r, _> <- removals.declarations) {
		for (<a, _> <- additions.declarations, r.scheme == a.scheme) {
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
				if (score > threshold) {
					result += buildMapping(r, a, score, MATCH_JACCARD);
					continue;
				}
			}
		}
	}
	
	return result;
}