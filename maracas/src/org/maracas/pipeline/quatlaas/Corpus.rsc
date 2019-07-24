module org::maracas::pipeline::quatlaas::Corpus

import IO;
import lang::java::m3::Core;
import ValueIO;

void computeM3s(loc corpus, loc output, bool overwrite=false) {
	for (e <- listEntries(corpus)) {
		loc entry = corpus + e;
		
		if (isDirectory(entry)) {
			loc mLoc = output + "<e>.m3"; 
			
			if (overwrite || !exists(mLoc)) {
				println("Computing <e> M3...");
				M3 m = createM3FromDirectory(entry);
				println("Serializing <e> M3...");
				writeBinaryValueFile(mLoc, m);
			}
		}	
	}
}

