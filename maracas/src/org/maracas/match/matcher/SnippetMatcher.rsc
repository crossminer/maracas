module org::maracas::match::matcher::SnippetMatcher

import IO;
import List;
import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::config::Options;
import org::maracas::m3::Core;
import org::maracas::m3::M3Diff;
import org::maracas::match::fun::StringSimilarity;
import org::maracas::match::struc::Data;
import Relation;
import Set;


set[Mapping[loc]] levenshteinSnippetMatch(M3Diff diff, real threshold) 
	= levenshteinMatch(diff, createRepresentation(diff, threshold));

Data createRepresentation(M3Diff diff, real threshold) {
	dat = string();
	dat.threshold = threshold;
	dat.from = createSnippets(domain(diff.removals.declarations), diff.from);
	dat.to = createSnippets(domain(diff.additions.declarations), diff.to);
	return dat;
}

str createSnippet(loc elem, M3 owner)
	= (owner.id.extension == "jar") 
	? createSnippetForJar(elem, owner)
	: createSnippetForSourceCode(elem, owner);

map[loc, str] createSnippets(set[loc] declarations, M3 m)
	= (d : createSnippet(d, m) | d <- declarations, isTargetMember(d));

// We don't take into account declarations ordering 
private str createSnippetForJar(loc elem, M3 owner) 
	= memberDeclaration(elem, owner)
	+ getM3SortString(elem, memoizedContainment(owner))
	+ getM3SortString(elem, memoizedMethodInvocation(owner))
	+ getM3SortString(elem, memoizedFieldAccess(owner));
	
private str createSnippetForSourceCode(loc elem, M3 owner) 
	= readFile(getFirstFrom(memoizedDeclarations(owner)[elem]));
	
	
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