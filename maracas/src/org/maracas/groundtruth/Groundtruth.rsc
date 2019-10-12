module org::maracas::groundtruth::Groundtruth


import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::io::File;
import lang::java::m3::Core;

import Relation;
import Set;
import List;
import IO;

/**
 * TODOs/FIXMEs
 *
 *   - Maven error message parsing is extremely brittle
 *   - Overrides the client's configuration if it already uses one of these two plugins:
 *      + maven-dependency-plugin
 *      + build-helper-maven-plugin
 *      + maven-compiler-plugin
 *      + (which is very likely ;)
 *      + (and will break stuff)
 *   - javac reports 100 errors max. Could be fixed with the -Xmaxerrs/-Xmaxwarns flags
 */

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

void main() {
	loc homeDir = getUserHomeDir();
	loc oldApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.1/comp-changes-0.0.1.jar";
	loc newApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.2/comp-changes-0.0.2.jar";
	loc client = homeDir + ".m2/repository/maracas-data/comp-changes-client/0.0.1/comp-changes-client-0.0.1.jar";
	loc srcClient = homeDir + "temp/maracas/comp-changes-client-0.0.1.jar/target/extracted-sources";
	loc report = homeDir + "temp/maracas/comp-changes.txt";
	
	println("Recording compilation errors...");
	list[CompilerMessage] msgs = recordErrors(client, "maracas-data", "comp-changes", "0.0.1", "0.0.2");
	
	println("Computing M3 models...");
	M3 oldM3 = createM3FromJar(oldApi);
	M3 newM3 = createM3FromJar(newApi);
	M3 clientM3 = createM3FromJar(client);
	M3 sourceM3 = createM3FromDirectory(srcClient);
	
	println("Computing evolution models...");
	list[APIEntity] delta = compareJars(oldApi, newApi, "0.0.1", "0.0.2");
	set[Detection] detects = detections(clientM3, oldM3, newM3, delta); 
	set[Match] matches = matchDetectiosn(sourceM3, delta, detects, msgs);
	
	println("Generating report...");
	outputReport(sourceM3, delta, detects, msgs, matches, report);
	
	println("Done!");
}

Match createMatch(MatchType typ, Detection detect, str reason) = <typ, detect, reason>;
 
set[Match] matchDetectiosn(M3 sourceM3, list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs) {
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

void appendEmptyLine(loc path) = appendToFile(path, "<getLineSeparator()>");

void appendToFileLn(loc path, str line) {
	appendToFile(path, line);
	appendEmptyLine(path);
}

void outputReport(M3 sourceM3, list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs, set[Match] matches, loc path) {
	// Always rewrite file
	writeFile(path, "");
	appendMatches(matches, path);
	appendModelStats(delta, detects, msgs, path);
	appendErrorStats(sourceM3, detects, msgs, path);
}

private void appendMatches(set[Match] matches, loc path) {
	rel[MatchType, int] typesMatches = {};
	
	for (MatchType m <- domain(matches)) {
		appendToFileLn(path, "<m> matches:");
		
		rel[Detection, str] typeMatches = matches[m];
		typesMatches += <m, size(domain(typeMatches))>;
		
		for (Detection d <- domain(typeMatches)) {
			appendToFileLn(path, "For <d>:");
			
			for (str reason <- typeMatches[d]) {
				appendToFileLn(path, "\t<d>");
			}
			appendEmptyLine(path);
		}
		appendEmptyLine(path);
		appendEmptyLine(path);
	}
	
	for (MatchType m <- domain(typesMatches)) {
		appendToFileLn(path, "<m> cases: <getOneFrom(typesMatches[m])>");
	}
}

private void appendModelStats(list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs, loc path) {
	appendToFileLn(path, "Breaking changes: <size(delta)>");
	appendToFileLn(path, "Detections: <size(detects)>");
	appendToFileLn(path, "Compiler messages: <size(msgs)>");
}

private void appendErrorStats(M3 sourceM3, set[Detection] detects, list[CompilerMessage] msgs, loc path) {
	set[Detection] fp = falsePositives(detects, msgs, sourceM3);
	set[CompilerMessage] fn = falseNegatives(detects, msgs, sourceM3);
	
	appendToFileLn(path, "False positives: <size(fp)>");
	appendToFileLn(path, "False negatives: <size(fn)>");
}

set[CompilerMessage] potentialMatches(loc file, list[CompilerMessage] messages) =
	{msg | msg:message(msgFile, _, _, _, _) <- messages, msgFile.path == file.path};


set[Detection] falsePositives(set[Detection] detections, list[CompilerMessage] messages, M3 sourceM3) {
	return {d | d <- detections, isFalsePositive(d, messages, sourceM3)};
}

bool isFalsePositive(Detection d, list[CompilerMessage] messages, M3 sourceM3) {
	return isEmpty(matchingMessages(d, messages, sourceM3)); 
}

set[CompilerMessage] matchingMessages(Detection d, list[CompilerMessage] messages, M3 sourceM3) {
	return {m | m:message(file, line, column, _, _) <- messages, isIncludedIn(logicalToPhysical(sourceM3, d.elem), file, line, column)};
}

set[CompilerMessage] falseNegatives(set[Detection] detections, list[CompilerMessage] messages, M3 sourceM3) {
	return {msg | msg <- messages, isFalseNegative(msg, detections, sourceM3)};
}

bool isFalseNegative(CompilerMessage msg, set[Detection] detections, M3 sourceM3) {
	return isEmpty({d | d <- detections, message(file, line, column, _, _) := msg, isIncludedIn(logicalToPhysical(sourceM3, d.elem), file, line, column)});
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
