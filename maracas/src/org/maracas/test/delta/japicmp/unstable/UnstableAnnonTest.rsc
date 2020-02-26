module org::maracas::\test::delta::japicmp::unstable::UnstableAnnonTest

import List;

import org::maracas::\test::delta::japicmp::SetUp;
import org::maracas::\test::delta::japicmp::usage::Common;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JapiCmpUnstable;


test bool numberUnstableDecl() 
	= size(filterUnstableAnnon(delta)) == 6;