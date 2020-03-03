module org::maracas::maven::Maven

@javaClass{org.maracas.maven.Maven}
@reflect
public java loc downloadJar(str group, str artifact, str version, loc dest);

@javaClass{org.maracas.maven.Maven}
@reflect
public java loc downloadSources(str group, str artifact, str version, loc dest);

@javaClass{org.maracas.maven.Maven}
@reflect
public java loc extractJar(loc jar, loc dest);
