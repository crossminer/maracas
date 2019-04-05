module org::maracas::bc::M3

import IO;
import lang::java::m3::ClassPaths;
import lang::java::m3::Core;
import org::maracas::io::File;
import String;
import ValueIO;


@memo
M3 m3(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	if (project.scheme == "jar" || project.extension == "jar") {
		return createM3FromJar(project);
	}
	else {
		return m3FromFolder(project);
	}
}

M3 m3FromFolder(loc project, loc mvnExec=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	if (existFileWithName(project, "pom.xml") 
		|| existFileWithName(project, "MANIFEST.MF")) {
		
		// This step seems to take too long
		classPath = projectClassPath(project, mvnExec);
		
		return createM3FromFiles(project,
			fetchFilesByExtension(project, "java"),
			sourcePath=[project],
			classPath=classPath);
	}
	else {
		return createM3FromDirectory(project);
	}
}

private list[loc] projectClassPath(loc project, loc mvnExec) {
	classPaths = getClassPath(project, mavenExecutable=mvnExec);
	return [ *classPaths[cp] | cp <- classPaths ];
}

private set[loc] fetchFilesByExtension(loc directory, str extension) {
	set[loc] files = {};
	if (isDirectory(directory)) { 
		for (f <- directory.ls) {
			if (isDirectory(f)) {
				files += fetchFilesByExtension(f, extension);
			}
			if (isFile(f) && f.extension == "<extension>") {
				files += f;
			}
		}
	}
	return files;
}