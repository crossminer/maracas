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
			
			if (index == size(rest) || anonym == unknownSource) {
				return anonym;
			}
			anonym = resolve(original, anonym, begin, m);
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

//str anonymName = memberName(anonymClass);
private loc resolveAnonymousClass(loc parent, str anonymName, M3 m) {
	parent = resolveTypeScheme(parent, m);
	set[loc] children = m.containment[parent];
	loc anonymClass = parent + anonymName;
	anonymClass.scheme = "java+anonymousClass";

	if (anonymClass in children) {
		return anonymClass;
	}
	
	for (c <- children) {
		set[loc] localChildren = m.containment[c];
		anonymClass.path = (c + anonymName).path;
		
		if (anonymClass in localChildren) {
			return anonymClass;
		}
		if (hasAnonymousClass(localChildren, m)) {
			return parent;
		}
	}
	
	return unknownSource;
}

bool hasAnonymousClass(set[loc] locs, M3 m) {
	return if (loc l <- locs, isAnonymousClass(l)) true; else false;
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

