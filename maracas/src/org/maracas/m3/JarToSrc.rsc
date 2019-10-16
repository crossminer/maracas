module org::maracas::m3::JarToSrc

import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::m3::Core;

import IO;
import String;


loc transformNestedClass(loc logical, M3 m) {
	println("");
	println("Starting: <logical>");
	logical = transformInnerClass(logical); // |java+method:///pkg/A$1$1/m()| -> |java+method:///pkg/1/1/m()|
	logical = transformAnonymClassName(logical); // |java+method:///pkg/A/1/1/m()| -> |java+method:///pkg/A/$anonymous1/$anonymous1/m()|
	return resolveAnonymousClass(logical, m); // |java+method:///pkg/A/$anonymous1/$anonymous1/m()| -> |java+method:///pkg/A/n()/$anonymous1/n()/$anonymous1/m()|
}

private loc transformInnerClass(loc logical) {
	logical.path = replaceAll(logical.path, "$", "/");
	println("Inner: <logical>");
	return logical;
}

private loc transformAnonymClassName(loc logical) {
	bool match = true;
	do {
		logical.path = visit(logical.path) {
			case /\/<n:\d+>\// => "/$anonymous<n>/"
			case /\/<n:\d+>$/ => "/$anonymous<n>"
		}
		match = /\/\d+\// := logical.path;
	} while(match);
	return logical;
}

private loc resolveAnonymousClass(loc logical, M3 m) {
	loc anonym = logical;
	anonym.path = "";
	
	loc resolve(loc original, loc anonym, int begin, M3 m) {
		str focus = original.path[begin..];
		
		if (contains(focus, "$anonymous")) {
			int end = findFirst(focus, "/$anonymous");
			str parent = focus[..end];
			anonym.path = anonym.path + parent;
			
			str rest = focus[end + 1..];
			int index = contains(rest, "/") ? findFirst(rest, "/") : size(rest);
			str anonymName = rest[..index];
			begin = begin + end + index + 1;
			
			anonym = resolveAnonymousClass(anonym, anonymName, m);
			anonym = (anonym == unknownSource) ? anonym : resolve(original, anonym, begin, m);
		}
		else {
			anonym.scheme = original.scheme;
			anonym.path = (!isEmpty(focus)) ? anonym.path + focus : anonym.path;
		}
		
		return anonym;
	}
	
	res = resolve(logical, anonym, 0, m);
	println("Anonymous: <res>");
	
	return res;
}

private loc resolveAnonymousClass(loc original, loc anonym, int begin, M3 m) {
	str focus = original.path[begin..];
	
	if (contains(focus, "$anonymous")) {
		int end = findFirst(focus, "/$anonymous");
		str parent = focus[..end];
		anonym.path = anonym.path + parent;
		
		str rest = focus[end + 1..];
		int index = contains(rest, "/") ? findFirst(rest, "/") : size(rest);
		str anonymName = rest[..index];
		
		rest = rest[index..];
		anonym = resolveAnonymousClass(anonym, anonymName, m);
		anonym = (anonym == unknownSource) ? anonym 
			: resolveAnonymousClass(original, anonym, begin + end + index + 1, m);
	}
	else {
		anonym.scheme = original.scheme;
		anonym.path = (!isEmpty(focus)) ? anonym.path + focus : anonym.path;
	}
	
	return anonym;
}

//str anonName = memberName(anonClass);
private loc resolveAnonymousClass(loc parent, str anonName, M3 m) {
	parent = resolveTypeScheme(parent, m);
	set[loc] children = m.containment[parent];
	loc anonClass = parent + anonName;
	anonClass.scheme = "java+anonymousClass";

	if (anonClass in children) {
		return anonClass;
	}
	
	for (c <- children) {
		set[loc] localChildren = m.containment[c];
		anonClass.path = (c + anonName).path;
		
		if (anonClass in localChildren) {
			return anonClass;
		}
	}
	
	return unknownSource;
}

// Only considering java+class and java+interface cases
// Enums and annotations are left behind
private loc resolveTypeScheme(loc logical, M3 m) {
	logical.scheme = "java+class";
	if (!isDeclared(logical, m)) {
		logical.scheme = "java+interface";
	}
	if (!isDeclared(logical, m)) {
		logical.scheme = "java+anonymousClass";
	}
	if (!isDeclared(logical, m)) {
		logical.scheme = "java+enum";
	}
	
	return logical;
}

