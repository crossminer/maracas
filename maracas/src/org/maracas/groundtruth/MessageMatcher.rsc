module org::maracas::groundtruth::MessageMatcher

import analysis::m3::AST;
import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::m3::Core;
import org::maracas::m3::JarToSource;
import org::maracas::m3::SourceToJar;

import IO;
import List;
import Location;
import Message;
import Set;
import String;

data CompilerMessage = message(
	loc file,            // Affected file
	int line,            // Line
	int column,          // Column (this is the only information we have...)
	str message,         // Error message
	map[str, str] params // Additional parameters of the error (affected symbol, location, etc.)
);

CompilerMessage emptyMsg() = message(unknownSource, -1, -1, "", ());

data MatchType 
	= matched()    // Detection -> Compilation message
	| unmatched()  // Detection -> No compilation message
	| candidates() // Detection -> Many compilation messages
	| unknown()    // Cannot find the physical location of the affected client entity
	;

alias Match = tuple[MatchType typ, Detection detect, CompilerMessage msg]; 

list[CompilerMessage] computeJDTErrors(M3 srcClient) 
	= computeJDTMessage(srcClient, isDetectedMsg);

list[CompilerMessage] computeJDTWarning(M3 srcClient) 
	= computeJDTMessage(srcClient, isWarningMsg);

list[CompilerMessage] computeJDTMessage(M3 srcClient, bool (Message) predicate) 
	= [ msgToCompilerMsg(m) | Message m <- srcClient.messages, predicate(m) ];

bool isDetectedMsg(Message msg) = isErrorMsg(msg) || isDeprecatedMsg(msg);
bool isErrorMsg(Message msg) = error(_, _) := msg || error(_) := msg;
bool isWarningMsg(Message msg) = warning(_, _) := msg;
bool isDeprecatedMsg(Message msg) = warning(m, _) := msg && /is deprecated$/ := m;

CompilerMessage msgToCompilerMsg(error(str msg, loc at))
	= msgToCompilerMsg(msg, at);

CompilerMessage msgToCompilerMsg(warning(str msg, loc at))
	= msgToCompilerMsg(msg, at);

CompilerMessage msgToCompilerMsg(str msg, loc at)
	= message(at, at.begin.line, at.begin.column, msg, ());
	
CompilerMessage msgToCompilerMsg(error(str msg))
	= message(unknownSource, -1, -1, msg, ());
	
set[Match] matchDetections(M3 sourceM3, Evolution evol, set[Detection] detects, list[CompilerMessage] msgs) {
	set[Match] checks = {};
	
	for (Detection d <- detects) {
		loc physLoc = logicalToPhysical(sourceM3, d.elem);
		set[CompilerMessage] matches = matchingMessages(d, msgs, sourceM3);
		
		if (!isEmpty(matches)) {
			checks += { <matched(), d, msg> | CompilerMessage msg <- matches };
		}
		else if (physLoc == |unknown:///|) {
			println("Unknown physical location for <d.elem>");
			// Skip if we are dealing with an inherited method from a protected class
			if (!isInheritedMethod(d.elem, sourceM3, evol.apiOld)) {
				checks += <unknown(), d, emptyMsg()>;
			}
		}
		else {
			set[CompilerMessage] candidats = potentialMatches(physLoc, msgs);
			checks += (isEmpty(candidats)) 
				? <unmatched(), d, emptyMsg()>
				: { <candidates(), d, msg> | CompilerMessage msg <- candidats };
		}
	}

	return checks;
}

set[CompilerMessage] getUnmatchCompilerMsgs(M3 sourceM3, set[Match] matches, list[CompilerMessage] msgs) {
	set[CompilerMessage] matchMsgs = matches.msg;
	set[CompilerMessage] candidateMsgs = toSet(msgs) - matchMsgs;
	return candidateMsgs - getImportMessages(sourceM3, candidateMsgs);
}

set[CompilerMessage] getImportMessages(M3 sourceM3, set[CompilerMessage] msgs) {
	rel[loc, loc] decls = sourceM3.declarations;
	return { m | m <- msgs, <e, p> <- decls, isClass(e) && isBefore(m.file, p) }; // TODO: Can be optimized (profile first)
}

set[CompilerMessage] potentialMatches(loc file, list[CompilerMessage] messages) =
	{ msg | msg:message(msgFile, _, _, _, _) <- messages, msgFile.path == file.path };

set[CompilerMessage] matchingMessages(Detection d, list[CompilerMessage] messages, M3 sourceM3) {
	return { m | m:message(file, line, column, _, _) <- messages,
		isIncludedIn(logicalToPhysical(sourceM3, d.elem), file, line, column) };
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

void prettyPrint(set[Match] matches, M3 sourceM3) {
	for (<typ, d, msg> <- matches) {
		loc phys = logicalToPhysical(sourceM3, d.elem);

		println(
			"[<typ>] \<<d.change>\>
				'Elem: <d.elem> (<phys.begin.line>, <phys.begin.column>) 
				'Uses: <d.used>
				'Msg:  <msg.message>
			");
	}
}

// FIXME: missing information related to the API.
// This will happen only when the parent class has protected modifier.
// However, we don't have information related to the API modifiers.
bool isInheritedMethod(loc meth, M3 sourceM3, M3 api) {
	if (!isDeclared(meth, sourceM3)) {
		loc class = resolveMethClass(transformNestedClass(meth, sourceM3), sourceM3);
		set[loc] extends = sourceM3.extends[class];
		
		if (!isEmpty(extends)) {
			loc super = getOneFrom(extends);
			super = toJarInnerClass(super);
			set[loc] children = api.containment[super];
			set[Modifier] modifs = api.modifiers[super];
			loc inheritedMeth = super + methodSignature(meth);
			inheritedMeth.scheme = meth.scheme;

			return inheritedMeth in children && protected() in modifs;
		}
	}
	return false;
}