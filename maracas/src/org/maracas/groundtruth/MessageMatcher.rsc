module org::maracas::groundtruth::MessageMatcher

import analysis::m3::AST;
import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::m3::Core;
import org::maracas::m3::JarToSource;

import IO;
import Message;
import Set;
import String;


data CompilerMessage = message(
	loc file, // Affected file
	int line, // Line
	int column, // Column (this is the only information we have...)
	str message, // Error message
	map[str, str] params // Additional parameters of the error (affected symbol, location, etc.)
);

data MatchType 
	= matched()
	| unmatched()
	| candidates()
	| unknown()
	;

alias Match = tuple[MatchType typ, Detection detect, str reason];

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{}
java bool upgradeClient(loc clientJar, str groupId, str artifactId, str v1, str v2);

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{}
java list[CompilerMessage] computeJavacErrors(loc pomFile);

list[CompilerMessage] computeJDTErrors(M3 srcClient) 
	= [ msgToCompilerMsg(m) | Message m <- srcClient.messages, isErrorMsg(m) ];

bool isErrorMsg(Message msg) = error(_, _) := msg || error(_) := msg;

CompilerMessage msgToCompilerMsg(error(str msg, loc at))
	= message(at, at.begin.line, at.begin.column, msg, ());

CompilerMessage msgToCompilerMsg(error(str msg))
	= message(unknownSource, -1, -1, msg, ());
	
Match createMatch(MatchType typ, Detection detect, str reason) = <typ, detect, reason>;
 
set[Match] matchDetections(M3 sourceM3, list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs) {
	set[Match] checks = {};
	
	for (Detection d <- detects) {
		loc physLoc = logicalToPhysical(sourceM3, d.elem);
		set[CompilerMessage] matches = matchingMessages(d, msgs, sourceM3); // Calling logicalToPhysical twice
		
		if (!isEmpty(matches)) {
			checks += { createMatch(matched(), d, "Matched by <msg>") | CompilerMessage msg <- matches };
		}
		else if (physLoc == |unknown:///|) {
			// Skip if we are dealing with an inherited method from a protected class
			if (!isInheritedMethod(d.elem, sourceM3)) {
				checks += createMatch(unknown(), d, "Couldn\'t find <d.elem> in source code.");
			}
		}
		else {
			set[CompilerMessage] candidats = potentialMatches(physLoc, msgs);
			checks += (isEmpty(candidats)) 
				? createMatch(unmatched(), d, "No compiler message on <physLoc.path>")
				: { createMatch(candidates(), d, "Compiler messages on file <physLoc.path>: <msg>") | CompilerMessage msg <- candidats };
		}
	}
	return checks;
}

set[CompilerMessage] getUnmatchCompilerMsgs(set[Match] matches, list[CompilerMessage] msgs) {
	set[CompilerMessage] matchMsgs = domain(range(matches));
	return toSet(msgs) - matchMsgs;
}

set[CompilerMessage] potentialMatches(loc file, list[CompilerMessage] messages) =
	{msg | msg:message(msgFile, _, _, _, _) <- messages, msgFile.path == file.path};

set[CompilerMessage] matchingMessages(Detection d, list[CompilerMessage] messages, M3 sourceM3) {
	return {m | m:message(file, line, column, _, _) <- messages, isIncludedIn(logicalToPhysical(sourceM3, d.elem), file, line, column)};
}

bool isIncludedIn(loc location, loc path, int line, int column) {
	bool res =
	   path.path == location.path
	&& line >= location.begin.line
	&& line <= location.end.line;
	//&& column >= location.begin.column
	//&& column <= location.end.column;
	
	return res;
}

loc logicalToPhysical(M3 m, loc logical) {
	loc physical = getDeclaration(logical, m);
	
	// 1. Check if the element is declared
	if (physical != unknownSource) {
		return physical;
	}
	
	// 2. Transform nested class locations and check again
	logical = transformNestedClass(logical, m);
	physical = getDeclaration(logical, m);
	if (physical != unknownSource) {
		return physical;
	}
	
	// 3. Check if it is an implicit constructor and return parent class
	logical = (isConstructor(logical)) ? resolveMethClass(logical, m) : logical;
	return getDeclaration(logical, m);
}

// FIXME: missing information related to the API.
// This will happen only when the parent class has protected modifier.
// However, we don't have information related to the API modifiers.
bool isInheritedMethod(loc meth, m) {
	if (!isDeclared(meth, m)) {
		loc class = resolveMethClass(transformNestedClass(meth, m), m);
		set[loc] extends = m.extends[class];
		
		if (!isEmpty(extends)) {
			loc super = getOneFrom(extends);
			set[loc] children = m.containment[super];
			set[Modifier] modifs = m.modifiers[super];
			loc inheritedMeth = super + methodSignature(meth);
			inheritedMeth.scheme = meth.scheme;
		
			return inheritedMeth in children && protected() in modifs;
		}
	}
	return false;
}