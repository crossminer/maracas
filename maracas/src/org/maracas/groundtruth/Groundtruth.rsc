module org::maracas::groundtruth::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::groundtruth::Compiler;
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
	set[Match] matches = matchDetections(sourceM3, delta, detects, msgs);
	
	println("Generating report...");
	outputReport(sourceM3, delta, detects, msgs, matches, report);
	
	println("Done!");
}