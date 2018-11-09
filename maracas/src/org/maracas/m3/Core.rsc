module org::maracas::m3::Core

import IO;
import lang::java::m3::AST;
import lang::java::m3::ClassPaths;
import lang::java::m3::Core;
import org::maracas::io::File;
import String;
import util::FileSystem;


@memo
M3 m3FromFiles(loc project, set[loc] files, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) =
	createM3FromFiles(
		project,
		files,
		classPath=classPath(project, mvnExec)
	);

@memo
M3 m3FromProject(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	set[loc] files = find(project, "java");
	return m3FromFiles(project, files, mvnExec=mvnExec);
}

Declaration astFromFile(loc file) =
	createAstFromFile(
		file, 
		true, 
		classPath=classPath(project, mvnExec)
	);

private list[loc] classPath(loc project, loc mvnExec) =
	(existFileWithName(project, "pom.xml") || existFileWithName(project, "MANIFEST.MF")) ?
		classPathFromMaven(project, mvnExec) : 
		classPathFromJars(project);

private list[loc] classPathFromMaven(loc project, loc mvnExec) {
	classPaths = getClassPath(project, mavenExecutable=mvnExec);
	return [*classPaths[cp] | cp <- classPaths];
}

private list[loc] classPathFromJars(loc project) {
	// Code taken from lang::java::m3::Core. Consider including it in the Rascal API.
	classPath = [];
    seen = {};
    for (j <- find(project, "jar"), isFile(j)) {
        hash = md5HashFile(j);
        if (!(hash in seen)) {
            classPath += j;
            seen += hash;
        }
    }
    return classPath;
}