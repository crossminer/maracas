module org::maracas::groundtruth::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::io::File;
import lang::java::m3::Core;

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

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{}
java list[CompilerMessage] recordErrors(loc clientJar, str groupId, str artifactId, str v1, str v2);

void main() {
	loc homeDir = getUserHomeDir();
	loc oldApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.1/comp-changes-0.0.1.jar";
	loc newApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.2/comp-changes-0.0.2.jar";
	loc client = homeDir + ".m2/repository/maracas-data/comp-changes-client/0.0.1/comp-changes-client-0.0.1.jar";
	loc srcClient = homeDir + "temp/maracas/comp-changes-client-0.0.1.jar/target/extracted-sources";
	
	M3 oldM3 = createM3FromJar(oldApi);
	M3 newM3 = createM3FromJar(newApi);
	M3 clientM3 = createM3FromJar(client);

	list[APIEntity] delta = compareJars(oldApi, newApi, "0.0.1", "0.0.2");
	set[Detection] detections = detections(clientM3, oldM3, newM3, delta); 
	list[CompilerMessage] msgs = recordErrors(client, "maracas-data", "comp-changes", "0.0.1", "0.0.2");
	
	M3 sourceM3 = createM3FromDirectory(srcClient);
	
	println("<size(delta)> breaking changes");
	println("<size(detections)> detections");
	println("<size(msgs)> compiler messages");
	
	for (Detection d <- detections) {
		loc physLoc = logicalToPhysical(sourceM3, d.elem);
		set[CompilerMessage] matches = matchingMessages(d, msgs, sourceM3);
		
		println("For <d>:");
		
		if (!isEmpty(matches)) {
			for (CompilerMessage msg <- matches)
				println("\tMatched by <msg>");
		}
		else if (physLoc == |unknown:///|) {
			println("\tCouldn\'t find <d.elem> in source code.");
		}
		else {
			set[CompilerMessage] candidates = potentialMatches(physLoc, msgs);
			
			if (isEmpty(candidates))
				println("\tNo compiler message on <physLoc.path>");
			else {
				println("\tCompiler messages on file <physLoc.path>:");
				for (CompilerMessage msg <- candidates)
					println("\t\t<msg>");
			}
		}
	}
	
	set[Detection] fp = falsePositives(detections, msgs, sourceM3);
	println("Found <size(fp)> false positives");
	
	set[CompilerMessage] fn = falseNegatives(detections, msgs, sourceM3);
	println("Found <size(fn)> false negatives");
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
