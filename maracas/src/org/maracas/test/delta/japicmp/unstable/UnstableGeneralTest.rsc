module org::maracas::\test::delta::japicmp::unstable::UnstableGeneralTest

import Set;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;


test bool unstablePlusStable()
	= size(filterStableDetections(detects, delta)) 
	+ size(filterUnstableDetections(detects, delta))
	== size(detects);