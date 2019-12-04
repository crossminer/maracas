@doc{
	This code has been extracted from 
	https://github.com/cwi-swat/rascal-java-build-manager
	@authors Jurgen Vinju and Davy Landman
}
module org::maracas::m3::ClassPaths

@javaClass{org.maracas.m3.internal.ClassPaths}
@reflect{for debugging}
java map[loc,list[loc]] getClassPath(
  loc workspace, 
  map[str,loc] updateSites = (x : |http://download.eclipse.org/releases| + x | x <- ["indigo", "juno", "kepler", "luna", "mars", "neon", "oxygen", "photon", "helios", "galileo", "2018-12", "2019-12"]),
  loc mavenExecutable = |file:///usr/local/bin/mvn|);
  