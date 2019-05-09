module org::maracas::match::matcher::Matcher

import lang::csv::IO;
import org::maracas::delta::Delta;
import org::maracas::config::Options;
import org::maracas::m3::M3Diff;


data Matcher = matcher(
	set[Mapping[loc]] (M3Diff diff, real threshold) match);
	

/*
 * Loads a set of matches from a CSV file. Default deparator: ",".
 */
set[Mapping[loc]] loadMatches(loc csv) {
	matches = readCSV(#rel[loc from, loc to], csv);
	// If matches are given, then confidence must be equal to 1.
	return matches join {<1.0, MATCH_LOAD>}; 
}