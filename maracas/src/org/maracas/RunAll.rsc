/*
 * Temporary, for FOCUS purposes.
 */
module org::maracas::RunAll

import IO;
import ValueIO;
import String;
import Set;
import Relation;
import org::maracas::Maracas;
import org::maracas::delta::Delta;
import org::maracas::delta::Migration;
import org::maracas::delta::vis::Visualizer;
import lang::java::m3::Core;
import org::maracas::delta::Detector;

void runAll(loc libv1, loc libv2, loc clients, loc report, bool serializeDelta, bool serializeHtml) {
	set[loc] clients = walkJARs(clients);
	int count = size(clients);

	println("Computing Delta model...");
	Delta d = delta(libv1, libv2);

	println("Pruning breaking changes...");
	d = breakingChanges(d);

	if (serializeDelta) {
		println("Serializing Delta model...");
		writeBinaryValueFile(report + "Delta.delta", d);
	}

	if (serializeHtml) {
		println("Serializing HTML report...");
		writeHtml(report + "Delta.html", d);
	}

	int i = 0;
	for (client <- clients) {
		i = i + 1;
		println("[<i>/<count>] Computing detection model for <client>... ");

		M3 m3 = createM3FromJar(client);	
		set[Detection] detects = detections(m3, d);

		if (size(detects) > 0)
			writeBinaryValueFile(report + "detection" + (client.file + ".detection"), detects);
	}
}

void runAllMigrations(loc report, loc clients) {
	set[Detection] ds = {};

	for (str e <- listEntries(report + "detection")) {
		//ds += { d | d <- readBinaryValueFile(#set[Detection], report + "detection" + e),
		//			d.typ != removed() }; // Not interested in those ones, yet
		ds += readBinaryValueFile(#set[Detection], report + "detection" + e);
	}

	println("Found <size(ds)> detection models");

	set[Migration] ms = buildMigrations(ds, clients);
	
	println("Found <size(ds)> migrations");
	
	writeBinaryValueFile(report + "Migrations.migration", ms);

	println("HTML report...");
	
	writeHtml(report + "Migrations.html", ms);
}

rel[str, set[Detection]] parseDetectionFiles(loc report) {
	rel[str, set[Detection]] result = {};

	for (e <- listEntries(report), endsWith(e, ".detection")) {
		if (/^<name: \S*>\.jar\.detection$/ := e) {
			loc entry = report + e;
			set[Detection] detects = readBinaryValueFile(#set[Detection], entry);
			result[name] += detects;
		} else
			throw "Shouldn\'t be here";
	}

	return result;
}

Delta parseDeltaFile(loc report) {
	loc d = report + "Delta.delta";

	if (isFile(d))
		return readBinaryValueFile(#Delta, d);
	else throw "<d> not found";
}

set[loc] walkJARs(loc dataset) {
	set[loc] result = {};

	for (e <- listEntries(dataset)) {
		loc entry = dataset + e;

		if (isDirectory(entry))
			result += walkJARs(entry);
		else if (endsWith(e, ".jar"))
			result += entry;
	};

	return result;
}
