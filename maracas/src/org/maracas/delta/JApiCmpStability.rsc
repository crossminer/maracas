module org::maracas::delta::JApiCmpStability

import String;


public set[str] unstableAnnons 
	= { "beta", "alpha", "unstable", "experiment", "internal", "private", "protected", "removal", "evolv", "notinherit", "dev" };
	
public set[str] unstablePkgs
	= { "beta", "alpha", "unstable", "experiment", "internal", "removal", "dev", "test" };


bool isUnstableAnnon(loc annon) 
	= containsKeyword(annon.file, unstableAnnons);

// TODO: what if the method and field is contained in class 
// that contains one of the keywords?	
bool isUnstableAPI(loc elem)
	= containsKeyword(elem.parent.path, unstablePkgs);
	
private bool containsKeyword(str path, set[str] keywords) {
	str pathLow = toLowerCase(path);
	
	if (str k <- keywords, contains(pathLow, k)) {
		return true;
	}
	return false;
}