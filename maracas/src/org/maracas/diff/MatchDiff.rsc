module org::maracas::diff::MatchDiff

import IO;
import lang::java::m3::AST;
import lang::java::m3::Core;
import Relation;


alias Match = rel[loc old, loc new];


/*
 * 1. Consider: packages, classes, public fields, public methods 
 * 2. Match by signature
 * 3. Match by AST
 */
@memo
Match matchM3s(M3 m3Old, M3 m3New) {
	apiElemsOld = apiElements(m3Old);
	apiElemsNew = apiElements(m3New);
	
	apiMatch = ident(apiElemsOld & apiElemsNew);
	return apiMatch;
}

/*
 * [Assumption]
 * A declaration is considered an API element if it is
 * either a package, class, interface, or enum,
 * or if it contains a public modifier.
 */
set[loc] apiElements(M3 m) = 
	{e | <e,l> <- m.declarations, isPackage(e) 
		|| isClass(e) 
		|| isInterface(e) 
		|| isEnum(e) 
		|| \public() in m.modifiers[e]};