module org::maracas::delta::stats::Statistics

import org::maracas::delta::Delta;
import org::maracas::delta::Detector;
import org::maracas::delta::Migration;

import Map;
import Node;
import Set;


rel[str, int] computeStatistics(Delta delt) {
	kws = getKeywordParameters(delt);
	rel[str, int] stats = {};
	
	for (str name <- kws) {
		value v = kws[name];

		if (rel[loc, Mapping[&T]] relation := v) {
			stats += <name, size(relation)>;
		}
	}
		
	return stats;
}

rel[str, int] computeStatistics(set[Detection] detects) {
	map[str, int] types = getDeltaTypesMap();
	
	for (detection(_, _, _, _, typ) <- detects) {
		str name = getName(typ);
		types[name] = types[name] + 1;
	}
	
	return toRel(types);
}

rel[str, int] computeStatistics(set[Migration] migs) {
	map[str, int] types = getDeltaTypesMap();
	
	for (migration(_, _, detection(_, _, _, _, typ)) <- migs) {
		str name = getName(typ);
		types[name] = types[name] + 1;
	}
	
	return toRel(types);
}

private map[str, int] getDeltaTypesMap() {
	set[DeltaType] types = getDeltaTypes();
	return ( getName(t) : 0 | t <- types);
}

private set[DeltaType] getDeltaTypes()
	= {
		accessModifiers(),
		finalModifiers(),
		staticModifiers(),
		abstractModifiers(),
		paramLists(),
		types(),
		extends(),
		implements(),
		deprecated(),
		renamed(),
		moved(),
		removed(),
		added()
	};

real precision(set[Migration] migs) 
	= (0.0 + truePositives(migs)) / (truePositives(migs) + falsePositives(migs));
	
int truePositives(set[Migration] migs) 
	= (0 | it + 1 | m <- migs, m.newUsed in m.newUses);

int falsePositives(set[Migration] migs) 
	= (0 | it + 1 | m <- migs, m.newUsed != |unknown:///|, m.newUsed notin m.newUses);

// TODO
//int falseNegatives(set[Migration] migs);