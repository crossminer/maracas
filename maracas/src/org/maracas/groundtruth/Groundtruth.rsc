module org::maracas::groundtruth::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::groundtruth::MessageMatcher;
import org::maracas::groundtruth::Report;
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

void main() {
	loc homeDir = getUserHomeDir();
	loc oldApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.1/comp-changes-0.0.1.jar";
	loc newApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.2/comp-changes-0.0.2.jar";
	loc client = homeDir + ".m2/repository/maracas-data/comp-changes-client/0.0.1/comp-changes-client-0.0.1.jar";
	
	loc clientDir = homeDir + "temp/maracas/comp-changes-client-0.0.1.jar/";
	loc srcClient = clientDir + "target/extracted-sources";
	loc clientPom = clientDir + "pom.xml";
	loc javacReport = clientDir + "report/comp-changes-javac.txt";
	loc jdtReport = clientDir + "report/comp-changes-jdt.txt";
	
	println("Upgrading client project");
	bool upgraded = upgradeClient(client, "maracas-data", "comp-changes", "0.0.1", "0.0.2");
	println("Client upgraded: <upgraded>");
	
	println("Computing M3 models");
	M3 oldM3 = createM3FromJar(oldApi);
	M3 newM3 = createM3FromJar(newApi);
	M3 clientM3 = createM3FromJar(client);
	M3 sourceM3 = createM3FromDirectory(srcClient, javaVersion="1.8");
	
	println("Recording compilation errors");
	//list[CompilerMessage] javacMsgs = computeJavacErrors(clientPom);
	list[CompilerMessage] jdtMsgs = computeJDTErrors(sourceM3);
	
	println("Computing evolution models");
	list[APIEntity] delta = compareJars(oldApi, newApi, "0.0.1", "0.0.2");
	Evolution evol = evolution(clientM3, oldM3, newM3, delta);
	set[Detection] detects = detections(clientM3, oldM3, newM3, delta); 
	
	println("Matching detections");
	//set[Match] javacMatches = matchDetections(sourceM3, evol, detects, javacMsgs);
	set[Match] jdtMatches = matchDetections(sourceM3, evol, detects, jdtMsgs);
	
	println("Generating report");
	//outputReport(sourceM3, delta, detects, javacMsgs, javacMatches, javacReport);
	outputReport(sourceM3, delta, detects, jdtMsgs, jdtMatches, jdtReport);
	
	println("Done!");
}