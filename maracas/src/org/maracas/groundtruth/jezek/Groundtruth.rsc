module org::maracas::groundtruth::jezek::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::groundtruth::MessageMatcher;
import org::maracas::groundtruth::Report;
import org::maracas::io::File;
import org::maracas::m3::Core;
import org::maracas::measure::delta::Evolution;

import lang::java::m3::AST;
import lang::java::m3::Core;

import IO;
import List;
import Set;
import util::ValueUI;

void runGroundtruth() {
	loc oldApi    = |file:///home/dig/repositories/jezek/lib-v1.jar|;
	loc newApi    = |file:///home/dig/repositories/jezek/lib-v2.jar|;
	loc client    = |file:///home/dig/repositories/jezek/client.jar|;
	loc srcClient = |file:///home/dig/repositories/jezek/client/src/|;
	loc jdtReport = |file:///home/dig/repositories/jezek/jdt.report|;
	
	println("Computing M3 models...");
	M3 oldM3    = createM3(oldApi);
	M3 newM3    = createM3(newApi);
	M3 clientM3 = createM3(client, classPath=[oldApi]);

	print("Compiling client with JDT... ");
	M3 sourceM3 = createM3FromDirectory(srcClient, javaVersion="1.8", classPath=[newApi]);
	println("<size(sourceM3.messages)> messages.");
	
	println("Computing delta...");
	list[APIEntity] delta = compareJars(oldApi, newApi, "v1", "v2");
	
	print("Computing detections... ");
	Evolution evol = createEvolution(clientM3, oldM3, newM3, delta);
	set[Detection] detects = computeDetections(evol);
	println("<size(detects)> detections found.");
	
	println("Matching detections with compiler messages...");
	list[CompilerMessage] jdtMsgs = computeJDTErrors(sourceM3);
	set[Match] matches = matchDetections(sourceM3, evol, detects, jdtMsgs);
	
	prettyPrint(matches, sourceM3);
	
	println("Generating report...");
	outputReport(oldApi, newApi, client, sourceM3, delta, detects,
		jdtMsgs, matches, jdtReport);
}
