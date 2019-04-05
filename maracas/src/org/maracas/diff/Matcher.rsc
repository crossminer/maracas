module org::maracas::diff::Matcher

import lang::csv::IO;
import lang::java::m3::Core;


data Matcher = matcher(
	set[Match] (M3 additions, M3 removals, bool (loc) fun) match);

alias Match 
	= tuple[
		loc from, 
		loc to,
		real confidence
	];

/*
 * Loads a set of matches from a CSV file. Default deparator: ",".
 */
set[Match] loadMatches(loc csv) {
	matches = readCSV(#rel[loc from, loc to], csv);
	// If matches are given, then confidence must be equal to 1.
	return matches join {1.0}; 
}