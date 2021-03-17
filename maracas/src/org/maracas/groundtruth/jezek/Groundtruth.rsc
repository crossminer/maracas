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
import Map;
import Set;
import String;
import util::ValueUI;
import util::Math;

void runJezek() {
	loc oldApi       = |file:///home/dig/repositories/jezek/lib-v1.jar|;
	loc newApi       = |file:///home/dig/repositories/jezek/lib-v2.jar|;
	loc client       = |file:///home/dig/repositories/jezek/client.jar|;
	loc srcClient    = |file:///home/dig/repositories/jezek/client/src/|;
	loc jdtReport    = |file:///home/dig/repositories/jezek/jdt.report|;
	loc linkerReport = |file:///home/dig/repositories/jezek/linker.report|;
	loc linkerOutput = |file:///home/dig/repositories/jezek/binary/|;
	//loc oldApi    = |file:///home/dig/repositories/maracas/data/comp-changes-old/target/comp-changes-0.0.1.jar|;
	//loc newApi    = |file:///home/dig/repositories/maracas/data/comp-changes-new/target/comp-changes-0.0.2.jar|;
	//loc client    = |file:///home/dig/repositories/maracas/data/comp-changes-client/target/comp-changes-client-0.0.1.jar|;
	//loc srcClient = |file:///home/dig/repositories/maracas/data/comp-changes-client/src|;
	//loc jdtReport = |file:///home/dig/jdt.report|;

	runJDTGroundtruth(oldApi, newApi, client, srcClient, jdtReport);
	runLinkerGroundtruth(oldApi, newApi, client, linkerOutput, linkerReport);
}

void runJDTGroundtruth(loc oldApi, loc newApi, loc client, loc srcClient, loc report) {
	println("Computing M3 models...");
	M3 oldM3    = createM3(oldApi);
	M3 newM3    = createM3(newApi);
	M3 clientM3 = createM3(client, classPath=[oldApi]);

	println("Computing delta...");
	list[APIEntity] delta = compareJars(oldApi, newApi, "v1", "v2");
	
	print("Computing detections... ");
	Evolution evol = createEvolution(clientM3, oldM3, newM3, delta);
	set[Detection] detects = { d |  d <- computeDetections(evol), d.change.sourceCompatibility == false };
	println("<size(detects)> detections found.");

	print("Compiling client with JDT... ");
	M3 sourceM3 = createM3FromDirectory(srcClient, javaVersion="1.8", classPath=[newApi]);
	list[CompilerMessage] jdtMsgs = computeJDTErrors(sourceM3);
	println("<size(jdtMsgs)> messages.");
	
	println("Matching detections with compiler messages...");
	set[Match] matches = matchDetections(sourceM3, evol, detects, jdtMsgs);
	
	set[CompilerMessage] fn = getUnmatchCompilerMsgs(sourceM3, matches, jdtMsgs);
	
	// Debug
	text({m | m <- matches, m.typ != matched()});
	text(fn);

	int tp = size({detect | <matched(), detect, _> <- matches});
	int ds = size(detects);
	int msgs = size(jdtMsgs);
	
	println("tp=<tp> ds=<ds> msgs=<msgs>");

	println("Precision: <tp / toReal(ds)>");
	println("Recall:    <tp / toReal(msgs)>");
	
	println("Generating report...");
	outputReport(oldApi, newApi, client, sourceM3, delta, detects,
		jdtMsgs, matches, report);
}

void runLinkerGroundtruth(loc oldApi, loc newApi, loc client, loc linkerOutput, loc report) {
	println("Computing M3 models...");
	M3 oldM3    = createM3(oldApi);
	M3 newM3    = createM3(newApi);
	M3 clientM3 = createM3(client, classPath=[oldApi]);

	println("Computing delta...");
	list[APIEntity] delta = compareJars(oldApi, newApi, "v1", "v2");
	
	print("Computing detections... ");
	Evolution evol = createEvolution(clientM3, oldM3, newM3, delta);
	set[Detection] detects = { d | d <- computeDetections(evol), d.change.binaryCompatibility == false };
	// TODO: filter binary-only detections
	println("<size(detects)> detections found.");
	
	print("Running Java linker... ");
	map[str, str] errors = parseLinkerOutput(linkerOutput);
	println("<size(errors)> linker errors found.");
	
	// d.elem points the precise location of the error,
	// but to match against the linker, we simply go up
	// to the containing 'Main' type after mapping linker
	// errors to Rascal locations
	map[loc, str] errorLocs = ( |java+class:///<replaceLast(cls, ".", "/")>| : errors[cls] | cls <- errors );
	set[loc] fn = {};
	set[loc] tp = {};
	set[loc] fp = {};
	for (loc cls <- errorLocs) {
		loc find = cls;
		
		set[Detection] matching = { d | d <- detects, d.elem == find || getOneFrom(clientM3.invertedContainment[d.elem]) == find };
		println("For <cls>: <size(matching)> matches [<{ d.change | d <- matching }>] [<{ d.use | d <- matching }>]");
		
		if (!isEmpty(matching))
			tp += find;
		else
			fn += find;
	}
	
	// FIXME: multiple detections for the same declaration... Let's just count one for P/R
	set[loc] uniqueDs = {};
	for (Detection d <- detects) {
		if (isClass(d.elem))
			uniqueDs += d.elem;
		else if (isField(d.elem) || isMethod(d.elem))
			uniqueDs += getOneFrom(clientM3.invertedContainment[d.elem]);
	}
	
	for (loc d <- uniqueDs) {
		if (d notin errorLocs<0>)
			fp += d;
	}
	
	println("Linker errors: <size(errorLocs)>. Detections: <size(uniqueDs)>. FP: <size(fp)>, FN: <size(fn)> TP: <size(tp)> P: <size(tp) / toReal(size(uniqueDs))>, R: <size(tp) / toReal(size(errorLocs))>");
}

map[str, str] parseLinkerOutput(loc dir) {
	map[str, int] errTypes = ();
	map[str, str] errors = ();

	for (str file <- listEntries(dir), endsWith(file, ".txt")) {
		str content = readFile(dir + file);
		set[str] linkageErrors = toSet([err | /java\.lang\.<err:.*>Error/m := content]);

		if (isEmpty(content)) {
			;
		} else if (size(linkageErrors) == 1) {
			str err = getOneFrom(linkageErrors);
			
			if (err in errTypes)
				errTypes[err] += 1;
			else
				errTypes += (err : 1);

			errors += (replaceLast(file, ".txt", "") : err);
		} else
			println("\tUnknown error(s)");
	}

	println("errTypes = <errTypes>");
	return errors;
}
