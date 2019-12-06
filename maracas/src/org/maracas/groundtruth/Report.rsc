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


bool generateReport(loc reportFile, M3 oldM3, M3 newM3, M3 clientM3, M3 sourceM3, list[APIEntity] delta) {
	println("Recording compilation errors");
	//list[CompilerMessage] javacMsgs = computeJavacErrors(clientPom);
	list[CompilerMessage] jdtMsgs = computeJDTErrors(sourceM3);
	
	println("Computing evolution models");
	Evolution evol = createEvolution(clientM3, oldM3, newM3, delta);
	set[Detection] detects = detections(evol); 
	
	if (detects != {}) {
		println("Matching detections");
		//set[Match] javacMatches = matchDetections(sourceM3, evol, detects, javacMsgs);
		set[Match] jdtMatches = matchDetections(sourceM3, evol, detects, jdtMsgs);
		
		println("Generating report");
		//outputReport(sourceM3, delta, detects, javacMsgs, javacMatches, javacReport);
		outputReport(sourceM3, delta, detects, jdtMsgs, jdtMatches, reportFile);
		println("Done!");
		return true;
	}
	return false;
}

void outputReport(M3 sourceM3, list[APIEntity] delta, set[Detection] detects, list[CompilerMessage] msgs, set[Match] matches, loc path) {
	// Always rewrite file
	writeFile(path, "");
	appendMatches(matches, path);
	appendUnmatchDetects(detects, matches, path);
	appendUnmatchMsgs(sourceM3, matches, msgs, path);
	appendModelStats(delta, detects, msgs, path);
	//appendErrorStats(sourceM3, detects, msgs, path);
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

private void appendUnmatchDetects(set[Detection] detects, set[Match] matches, loc path) {
	set[Detection] unmatchDetects = detects - matches<2>;
	appendTitle(path, "Unmatched Detections");
	
	for (Detection d <- unmatchDetects) {
		appendToFileLn(path, "<d>");
		appendEmptyLine(path);
	}
	appendEmptyLine(path);
	appendToFileLn(path, "Unmatched detections: <size(unmatchDetects)>");
	appendSectionEnd(path);
}

private void appendUnmatchMsgs(M3 sourceM3, set[Match] matches, list[CompilerMessage] msgs, loc path) {
	set[CompilerMessage] unmatchMsgs = getUnmatchCompilerMsgs(sourceM3, matches, msgs);
	appendTitle(path, "Unmatched Compiler Messages");
	
	for (CompilerMessage m <- unmatchMsgs) {
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
