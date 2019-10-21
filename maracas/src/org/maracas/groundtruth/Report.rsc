module org::maracas::groundtruth::Report

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::groundtruth::MessageMatcher;
import org::maracas::io::File;

import IO;
import List;
import Relation;
import Set;


void outputReport(M3 sourceM3, list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs, set[Match] matches, loc path) {
	// Always rewrite file
	writeFile(path, "");
	appendMatches(matches, path);
	appendUnmatchMsgs(matches, msgs, path);
	appendModelStats(delta, detects, msgs, path);
	appendErrorStats(sourceM3, detects, msgs, path);
}

private void appendMatches(set[Match] matches, loc path) {
	rel[MatchType, int] typesMatches = {};
	appendTitle(path, "Detection Matches");
	
	for (MatchType m <- domain(matches)) {
		appendToFileLn(path, "<m> matches:");
		
		rel[Detection, CompilerMessage] typeMatches = matches[m];
		typesMatches += <m, size(domain(typeMatches))>;
		
		for (Detection d <- domain(typeMatches)) {
			appendToFileLn(path, "For <d>:");
			
			for (CompilerMessage m <- typeMatches[d]) {
				appendToFileLn(path, "\t<m>");
			}
			appendEmptyLine(path);
		}
		appendEmptyLine(path);
		appendEmptyLine(path);
	}
	
	for (MatchType m <- domain(typesMatches)) {
		appendToFileLn(path, "<m> cases: <getOneFrom(typesMatches[m])>");
	}
	appendSectionEnd(path);
}

private void appendUnmatchMsgs(set[Match] matches, list[CompilerMessage] msgs, loc path) {
	set[CompilerMessage] unmatchMsgs = getUnmatchCompilerMsgs(matches, msgs);
	appendTitle(path, "Detection Unmatches");
	
	for (CompilerMessage m <- msgs) {
		appendToFileLn(path, "<m>");
		appendEmptyLine(path);
	}
	appendEmptyLine(path);
	appendToFileLn(path, "Unmatched messages: <size(unmatchMsgs)>");
	appendSectionEnd(path);
}

private void appendModelStats(list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs, loc path) {
	appendTitle(path, "Model Stats");
	appendToFileLn(path, "Breaking changes: <size(delta)>");
	appendToFileLn(path, "Detections: <size(detects)>");
	appendToFileLn(path, "Compiler messages: <size(msgs)>");
	appendSectionEnd(path);
}

private void appendErrorStats(M3 sourceM3, set[Detection] detects, list[CompilerMessage] msgs, loc path) {
	set[Detection] fp = falsePositives(detects, msgs, sourceM3);
	set[CompilerMessage] fn = falseNegatives(detects, msgs, sourceM3);
	
	appendTitle(path, "Error Stats");
	appendToFileLn(path, "False positives: <size(fp)>");
	appendToFileLn(path, "False negatives: <size(fn)>");
	appendSectionEnd(path);
}

private void appendTitle(loc path, str title) {
	appendToFileLn(path, "----------------------------");
	appendToFileLn(path, title);
	appendToFileLn(path, "----------------------------");
	appendEmptyLine(path);
}

private void appendSectionEnd(loc path) {
	appendEmptyLine(path);
	appendEmptyLine(path);
}

set[Detection] falsePositives(set[Detection] detections, list[CompilerMessage] messages, M3 sourceM3) 
	= {d | d <- detections, isFalsePositive(d, messages, sourceM3)};

bool isFalsePositive(Detection d, list[CompilerMessage] messages, M3 sourceM3)
	= isEmpty(matchingMessages(d, messages, sourceM3)); 

set[CompilerMessage] falseNegatives(set[Detection] detections, list[CompilerMessage] messages, M3 sourceM3)
	= {msg | msg <- messages, isFalseNegative(msg, detections, sourceM3)};

bool isFalseNegative(CompilerMessage msg, set[Detection] detections, M3 sourceM3) 
	= isEmpty({d | d <- detections, message(file, line, column, _, _) := msg, 
		isIncludedIn(logicalToPhysical(sourceM3, d.elem), file, line, column)});
