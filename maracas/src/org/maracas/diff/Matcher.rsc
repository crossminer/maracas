module org::maracas::diff::Matcher

import lang::csv::IO;
import lang::java::m3::Core;


data Matcher = matcher(
	set[Match] (M3 added, M3 removed) match);

alias Match 
	= tuple[
		int confidence, 
		tuple[loc from, loc to] match
	];

/*
 * Loads a set of matches from a CSV file. Default deparator: ",".
 */
set[Match] loadMatches(loc csv) {
	matches = readCSV(#rel[loc from, loc to], csv);
	// If matches are given, then confidence must be equal to 1.
	return {1} * matches;
}