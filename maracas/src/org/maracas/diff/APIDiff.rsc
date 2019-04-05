module org::maracas::diff::APIDiff

import lang::java::m3::Core;


/*
 * 1. Consider: packages, classes, public fields, public methods 
 * 2. Match by signature
 * 3. Match by AST
 */
tuple[M3,M3] matchM3s(M3 m3Old, M3 m3New) {
	apiElemsOld = apiElements(m3Old);
	apiElemsNew = apiElements(m3New);
	
	apiElemsIntersec = apiElemsOld & apiElemsNew;
	apiElemsOld = apiElemsOld - apiElemsIntersec;
	apiElemsNew = apiElemsNew - apiElemsIntersec;
	
	// Match by signature
	apiMatch = ident(apiElemsIntersec);
	
	
	return apiMatch;
}

/*
 * [Assumption]
 * A declaration is considered an API element if it is
 * either a package, class, interface, or enum,
 * or if it contains a public modifier.
 * TODO: what if its semantics change?
 */
set[loc] apiElements(M3 m) = 
	{ e | <e,l> <- m.declarations, isPackage(e) 
		|| isClass(e) 
		|| isInterface(e) 
		|| isEnum(e) 
		|| \public() in m.modifiers[e] };