module org::maracas::io::File

import IO;
import String;

bool existFileWithName(loc directory, str name) {
	if (isDirectory(directory)) {
		found = false;
		for (f <- directory.ls) {
			if (isDirectory(f)) {
				found = found || existFileWithName(f, name);
				if(found) {
					return true;
				}
			}
			if (isFile(f) && endsWith(f.path, "/<name>")) {
				return true;
			}
		}
	}
	return false;
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