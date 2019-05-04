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
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::vis::Visualizer;
import lang::java::m3::Core;
import org::maracas::bc::Detector;

void runAll(loc libv1, loc libv2, loc clients, loc report, bool serializeBC, bool serializeHtml) {
	set[loc] clients = walkJARs(clients);
	int count = size(clients);

	println("Computing CBC...");
	BreakingChanges cbc = classBreakingChanges(libv1, libv2);

	println("Computing MBC...");
	BreakingChanges mbc = methodBreakingChanges(libv1, libv2);

	println("Computing FBC...");
	BreakingChanges fbc = fieldBreakingChanges(libv1, libv2);

	if (serializeBC) {
		writeBinaryValueFile(report + "Classes.cbc", cbc);
		writeBinaryValueFile(report + "Methods.cbc", mbc);
		writeBinaryValueFile(report + "Fields.cbc", fbc);
	}

	if (serializeHtml) {
		writeHtml(report + "html" + "Classes.html", cbc);
		writeHtml(report + "html" + "Methods.html", mbc);
		writeHtml(report + "html" + "Fields.html", fbc);
	}

	int i = 0;
	for (client <- clients) {
		i = i + 1;
		print("[<i>/<count>] Computing detection model for <client>... ");		

		M3 m3 = createM3FromJar(client);	
		set[Detection] cDetections = detections(m3, cbc);
		set[Detection] mDetections = detections(m3, mbc);
		set[Detection] fDetections = detections(m3, fbc);

		if (size(cDetections) > 0)
			writeBinaryValueFile(report + (client.file + ".cbc.detection"), cDetections);
		if (size(mDetections) > 0)
			writeBinaryValueFile(report + (client.file + ".mbc.detection"), mDetections);
		if (size(fDetections) > 0)
			writeBinaryValueFile(report + (client.file + ".fbc.detection"), fDetections);
	}
}

void readDetectionFiles(loc dataset) {
	int total = 0;

	for (e <- listEntries(dataset), endsWith(e, ".detection")) {
		loc entry = dataset + e;

		set[Detection] detections = readBinaryValueFile(#set[Detection], entry);
		total += size(detections);
	}

	println("detections=<total>");
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
