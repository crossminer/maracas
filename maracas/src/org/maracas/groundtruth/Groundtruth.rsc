module org::maracas::groundtruth::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import lang::java::m3::Core;

import Set;
import List;
import IO;

import util::ValueUI;

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
	loc jar,
	// Affected file
	loc path,
	// Line
	int line,
	// Column (this is the only information we have...)
	int column,
	// Error message
	str message,
	// Additional parameters of the error (affected symbol, location, etc.)
	map[str, str] params
);

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{}
java list[CompilerMessage] recordErrors(loc clientJar, str groupId, str artifactId, str v1, str v2);

void main() {
	loc oldApi = |file:///home/dig/.m2/repository/maracas-data/comp-changes/0.0.1/comp-changes-0.0.1.jar|;
	loc newApi = |file:///home/dig/.m2/repository/maracas-data/comp-changes/0.0.2/comp-changes-0.0.2.jar|;
	loc client = |file:///home/dig/.m2/repository/maracas-data/comp-changes-client/0.0.1/comp-changes-client-0.0.1.jar|;
	
	M3 oldM3 = createM3FromJar(oldApi);
	M3 newM3 = createM3FromJar(newApi);
	M3 clientM3 = createM3FromJar(client);

	list[APIEntity] delta = compareJars(oldApi, newApi, "0.0.1", "0.0.2");
	set[Detection] detections = detections(clientM3, oldM3, newM3, delta); 
	list[CompilerMessage] msgs = recordErrors(client, "maracas-data", "comp-changes", "0.0.1", "0.0.2");
	
	println(size(delta));
	println(size(detections));
	println(size(msgs));
	
	text(msgs);
}

Detection toDetection(CompilerMessage msg) {
	loc jar = msg.jar;
	
	// elem should be the location of
	// the first enclosing element of
	// the code pointed by <path, line, column>
	// then, we must match 'message'
	// against the CompatibilityChange ADT

	return detection(jar, elem, used, mapping, typ);
}


set[Detection] falsePositives(set[Detection] detections, list[CompilerMessage] messages, M3 sourceM3) {
	return {d | d <- detections, isFalsePositive(d, messages, sourceM3)};
}

bool isFalsePositive(Detection d, list[CompilerMessage] messages, M3 sourceM3) {
	return isEmpty({path | message(path, line, column, _, _) <- messages, isIncludedIn(logicalToPhysical(sourceM3, d.elem), path, line, column)}); 
}

set[CompilerMessage] falseNegatives(set[Detection] detections, list[CompilerMessage] messages, loc clientSourceJar) {
	return {};
}

bool isIncludedIn(loc location, loc path, int line, int column) {
	println("is <line>,<column> in <location>?");
	
	return
	   location.file == path.file
	&& line >= location.begin.line
	&& line <= location.end.line;
	//&& column >= location.begin.column
	//&& column <= location.end.column;
}

@memo
loc logicalToPhysical(M3 m, loc logical) = getOneFrom(m.declarations[logical]);
