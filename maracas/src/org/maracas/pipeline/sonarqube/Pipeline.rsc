module org::maracas::pipeline::sonarqube::Pipeline

import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::delta::DeltaBuilder;
import org::maracas::delta::Detector;
import org::maracas::delta::stats::Statistics;
import org::maracas::m3::Core;

import DateTime;
import IO;
import lang::csv::IO;
import ValueIO;


Delta deltaSonar(loc oldAPI, loc newAPI) {
	M3 m3from = filterSonarInternals(createM3(oldAPI));
	M3 m3to = filterSonarInternals(createM3(newAPI));
	return createDelta(m3from, m3to);
}

/* 
 * Skipping all .class files located in /internal/
*/
M3 filterSonarInternals(M3 m) 
	= filterM3(m, 
		bool (value v1, value v2) {
			return isNotInternal(v1) && isNotInternal(v2);
		});

private bool isNotInternal(value v) 
	= /org\/sonar\/api\/internal\// !:= l.uri
	&& /internal\// !:= l.uri
	&& /test\// !:= l.uri
	when loc l := v;

private bool isNotInternal(value v) = true;

Delta computeDelta(loc v1, loc v2, loc output=|file:///temp/maracas/delta.bin|, bool store=true, bool rewrite = false) {
	if (rewrite || !exists(output)) {
		printMessage("Computing delta between <v1.path> and <v2.path>");
		Delta delt = deltaSonar(v1, v2);
	
		if (store) {
			printMessage("Writing delta as binary file");
			writeBinaryValueFile(output, delt);
		}
		return delt;
	}
	else {
		printMessage("Reading delta between <v1.path> and <v2.path>");
		return readBinaryValueFile(#Delta, output);
	}
}

Delta computeBreakingChanges(Delta delt, loc output=|file:///temp/maracas/bc.bin|, bool store=true, bool rewrite = false) {
	if (rewrite || !exists(output)) {
		printMessage("Getting breaking changes");
		Delta bc = breakingChanges(delt);
		
		if (store) {
			printMessage("Writing breaking changes as binary file");
			writeBinaryValueFile(output, delt);
		}
		return bc;
	}
	else {
		printMessage("Reading breaking changes");
		return readBinaryValueFile(#Delta, output);
	}
}

rel[str, int] computeDeltaStatistics(Delta delt, loc output=|file:///temp/maracas/delta-stats.csv|) {
	printMessage("Writing delta statistics as CSV file");
	rel[str change, int number] stats = computeStatistics(delt);
	writeCSV(stats, output);
	return stats;
}

set[Detection] computeDetections(loc clientv1, Delta delt, loc output=|file:///temp/maracas/detections.bin|, bool store = true, bool rewrite = false) {
	if (rewrite || !exists(output)) {
		printMessage("Computing detections for <clientv1>");
		set[Detection] det = detections(createM3(clientv1), delt);
		
		if (store) {
			printMessage("Writing detections as binary file");
			writeBinaryValueFile(output, det);
		}	
		return det;
	}
	else {
		printMessage("Reading detections for <clientv1>");
		return readBinaryValueFile(#set[Detection], output);
	}
}

rel[str, int] computeDetectionsStatistics(set[Detection] detects, loc output=|file:///temp/maracas/detections-stats.csv|) {
	printMessage("Writing detections statistics as CSV file");
	rel[str change, int number] stats = computeStatistics(detects);
	writeCSV(stats, output);
	return stats;
}

void printMessage(str msg, str flag = "INFO") {
	datetime time = now();
	println("<time>: [<flag>] <msg>");
}