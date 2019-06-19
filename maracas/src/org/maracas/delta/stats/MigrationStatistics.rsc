module org::maracas::delta::stats::MigrationStatistics

import org::maracas::delta::Detector;
import org::maracas::delta::Migration;
import org::maracas::delta::stats::Core;

import Map;
import Node;
import Set;


rel[str, int] casesPerChangeType(set[Migration] migs) {
	map[str, int] types = getDeltaTypesMap();
	
	for (migration(_, _, detection(_, _, _, _, typ)) <- migs) {
		str name = getName(typ);
		types[name] = types[name] + 1;
	}
	
	return toRel(types);
}

rel[str, int] truePositivesPerChangeType(set[Migration] migs)
	= casesPerChangeType(truePositives(migs));
	
rel[str, int] falsePositivesPerChangeType(set[Migration] migs)
	= casesPerChangeType(falsePositives(migs));
	
rel[str, int] falseNegativesPerChangeType(set[Migration] migs)
	= casesPerChangeType(falseNegatives(migs));


set[Migration] truePositives(set[Migration] migs) 
	= { m | m <- migs, m.newUsed in m.newUses };

set[Migration] falsePositives(set[Migration] migs) 
	= { m | m <- migs, m.newUsed != |unknown:///|, m.newUsed notin m.newUses };

set[Migration] falseNegatives(set[Migration] migs)
	= { m | m <- migs, m.newDecl != |unknown:///|, m.newUsed notin m.newUses };
		

int truePositivesSize(set[Migration] migs) 
	= size(truePositives(migs));
	
int falsePositivesSize(set[Migration] migs) 
	= size(falsePositives(migs));
	
int falseNegativesSize(set[Migration] migs)
	= size(falseNegatives(migs));
	

real precision(set[Migration] migs) 
	= (0.0 + truePositivesSize(migs)) / (truePositivesSize(migs) + falsePositivesSize(migs));

real recall(set[Migration] migs)
	= (0.0 + truePositivesSize(migs)) / (truePositivesSize(migs) + falseNegativesSize(migs));