module org::maracas::groundtruth::Compiler

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

import Set;


data CompilerMessage = message(
	// Affected file
	loc file,
	// Line
	int line,
	// Column (this is the only information we have...)
	int column,
	// Error message
	str message,
	// Additional parameters of the error (affected symbol, location, etc.)
	map[str, str] params
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
java list[CompilerMessage] recordErrors(loc clientJar, str groupId, str artifactId, str v1, str v2);

Match createMatch(MatchType typ, Detection detect, str reason) = <typ, detect, reason>;
 
set[Match] matchDetections(M3 sourceM3, list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs) {
	set[Match] checks = {};
	
	for (Detection d <- detects) {
		loc physLoc = logicalToPhysical(sourceM3, d.elem);
		set[CompilerMessage] matches = matchingMessages(d, msgs, sourceM3);
		
		if (!isEmpty(matches)) {
			checks += { createMatch(matched(), d, "Matched by <msg>") | CompilerMessage msg <- matches };
		}
		else if (physLoc == |unknown:///|) {
			checks += createMatch(unknown(), d, "Couldn\'t find <d.elem> in source code.");
		}
		else {
			set[CompilerMessage] candidates = potentialMatches(physLoc, msgs);
			checks += (isEmpty(candidates)) 
				? createMatch(unmatched(), d, "No compiler message on <physLoc.path>")
				: { createMatch(candidates(), d, "Compiler messages on file <physLoc.path>: <msg>") | CompilerMessage msg <- matches };
		}
	}
	return checks;
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

loc logicalToPhysical(M3 m, loc logical) = (isEmpty(m.declarations[logical])) ? |unknown:///| : getOneFrom(m.declarations[logical]);