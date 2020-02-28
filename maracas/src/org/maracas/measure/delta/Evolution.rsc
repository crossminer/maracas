module org::maracas::measure::delta::Evolution

import IO;
import List;
import Node;

import org::maracas::delta::JApiCmp;
import org::maracas::m3::M3Diff;

@doc {
	Returns the number of breaking changes in the whole delta.
}
int numberBreakingChanges(list[APIEntity] delta)
	= (0 | it + 1 | /CompatibilityChange ch := delta);

@doc {
	Returns the number of changes in the whole delta.
}
int numberChanges(list[APIEntity] delta)
	= numberAdded(delta) + numberRemoved(delta) + numberModified(delta);

int numberAdded(list[APIEntity] delta)
	= (0 | it + 1 | /APISimpleChange ch:APISimpleChange::new() := delta);

int numberRemoved(list[APIEntity] delta)
	= (0 | it + 1 | /APISimpleChange ch:APISimpleChange::removed() := delta);

int numberModified(list[APIEntity] delta)
	= (0 | it + 1 | /APISimpleChange ch:APISimpleChange::modified() := delta);

@doc {
	Returns the number of changes related to a given compatibility
	change type (e.g. classRemoved(), annotationDeprecatedAdded()).
}
int numberChangesPerType(list[APIEntity] delta, CompatibilityChange ch)
	= (0 | it + 1 | /ch := delta);

@doc {
	Returns a map that links compatibility change types to 
	the number of changes affecting each kind.
}
map[CompatibilityChange, int] numberChangesPerType(list[APIEntity] delta)
	= ( ch : numberChangesPerType(delta, ch) | ch <- getCompatibilityChanges(delta) );

@doc {
	Returns the number of modified types in the delta.
}
int numberChangedTypes(list[APIEntity] delta)
	= (0 | it + 1 | /class(_,_,_,chs,_,_) := delta, chs != []);

@doc {
	Returns the number of modified methods in the delta.
}
int numberChangedMethods(list[APIEntity] delta)
	= (0 | it + 1 | /method(_,_,_,chs,_,_) := delta, chs != [])
	+ (0 | it + 1 | /constructor(_,_,chs,_,_) := delta, chs != []);

@doc {
	Returns the number of modified fields in the delta.
}
int numberChangedFields(list[APIEntity] delta)
	= (0 | it + 1 | /field(_,_,_,chs,_,_) := delta, chs != []);

@doc {
	Returns a map that links API entities (i.e. types, methods,
	and fields) to the number of modified entities per kind.
}
map[str, int] numberChangedEntities(list[APIEntity] delta) 
	= (
		"Type"   : numberChangedTypes(delta),
		"Method" : numberChangedMethods(delta),
		"Field"  : numberChangedFields(delta)
	);

@doc {
	Returns the number of changes affecting types in the delta.
}
int numberTypeChanges(list[APIEntity] delta)
	= (0 | it + size(chs) | /class(_,_,_,chs,_,_) := delta, chs != []);

@doc {
	Returns the number of changes affecting methods in the delta.
}
int numberMethodChanges(list[APIEntity] delta)
	= (0 | it + size(chs) | /method(_,_,_,chs,_,_) := delta, chs != [])
	+ (0 | it + size(chs) | /constructor(_,_,chs,_,_) := delta, chs != []);

@doc {
	Returns the number of changes affecting fields in the delta.
}
int numberFieldChanges(list[APIEntity] delta)
	= (0 | it + size(chs) | /field(_,_,_,chs,_,_) := delta, chs != []);

@doc {
	Returns a map that links API entities (i.e. types, methods,
	and fields) to the number of changes affecting each kind.
}
map[str, int] numberEntityChanges(list[APIEntity] delta) 
	= (
		"Type" : numberTypeChanges(delta),
		"Method" : numberMethodChanges(delta),
		"Field" : numberFieldChanges(delta)
	);

@doc{
	Simple handy function that summarizes all delta stats.
	Though ugly, it makes invoking from Java much easier.
}
map[str, value] deltaStats(loc oldJar, loc newJar, str oldVersion, str newVersion, list[loc] old = [], list[loc] new = []) {
	list[APIEntity] delta = compareJars(oldJar, newJar, oldVersion, newVersion, oldCP = old, newCP = new);
	map[CompatibilityChange, int] bcs = numberChangesPerType(delta);
	map[str, value] stats = ( getName(c) : bcs[c] | c <- bcs );

	stats["delta"]          = delta;
	stats["bcs"]            = numberBreakingChanges(delta);
	stats["changes"]        = numberChanges(delta);
	stats["added"]          = numberAdded(delta);
	stats["removed"]        = numberRemoved(delta);
	stats["modified"]       = numberModified(delta);
	stats["brokenTypes"]    = numberChangedTypes(delta);
	stats["brokenMethods"]  = numberChangedMethods(delta);
	stats["brokenFields"]   = numberChangedFields(delta);
	stats["bcsOnTypes"]     = numberTypeChanges(delta);
	stats["bcsOnMethods"]   = numberMethodChanges(delta);
	stats["bcsOnFields"]    = numberFieldChanges(delta);

	return stats;
}
