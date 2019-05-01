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
import lang::java::m3::Core;
import org::maracas::bc::Detector;

void runAll(loc libv1, loc libv2, loc dataset) {
	loc clientsPath = dataset + "clients/";
	set[loc] clients = walkJARs(clientsPath);
	int count = size(clients);

	println("Computing CBC...");
	BreakingChanges cbc = classBreakingChanges(libv1, libv2);
	writeBinaryValueFile(dataset + "Classes.cbc", cbc);

	println("Computing MBC...");
	BreakingChanges mbc = methodBreakingChanges(libv1, libv2);
	writeBinaryValueFile(dataset + "Methods.cbc", mbc);

	println("Computing FBC...");
	BreakingChanges fbc = fieldBreakingChanges(libv1, libv2);
	writeBinaryValueFile(dataset + "Fields.cbc", fbc);

	int i = 0;
	for (client <- clients) {
		i = i + 1;
		print("[<i>/<count>] Computing detection model for <client>... ");		

		M3 m3 = createM3FromJar(client);	
		set[Detection] cDetections = detections(m3, cbc);
		set[Detection] mDetections = detections(m3, mbc);
		set[Detection] fDetections = detections(m3, fbc);

		if (size(cDetections) > 0)
			writeBinaryValueFile(dataset + (client.file + ".cbc.detection"), cDetections);
		if (size(mDetections) > 0)
			writeBinaryValueFile(dataset + (client.file + ".mbc.detection"), mDetections);
		if (size(fDetections) > 0)
			writeBinaryValueFile(dataset + (client.file + ".fbc.detection"), fDetections);
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
