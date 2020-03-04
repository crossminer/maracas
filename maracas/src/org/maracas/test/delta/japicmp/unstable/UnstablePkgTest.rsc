module org::maracas::\test::delta::japicmp::unstable::UnstablePkgTest

import List;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;

test bool numberUnstableDecls()
	= size(delta - filterStableAPIByName(delta)) == 14;
	

	 