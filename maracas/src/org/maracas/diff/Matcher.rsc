module org::maracas::diff::Matcher

import lang::csv::IO;
import org::maracas::bc::BreakingChanges;
import org::maracas::config::Options;
import org::maracas::m3::M3Diff;


data Matcher = matcher(
	set[Mapping[loc]] (M3Diff diff, bool (loc) fun) match);
	

/*
 * Loads a set of matches from a CSV file. Default deparator: ",".
 */
set[Mapping[loc]] loadMatches(loc csv) {
	matches = readCSV(#rel[loc from, loc to], csv);
	// If matches are given, then confidence must be equal to 1.
	return matches join {<1.0, MATCH_LOAD>}; 
}