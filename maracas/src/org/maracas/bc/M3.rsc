module org::maracas::bc::M3

import IO;
import lang::java::m3::ClassPaths;
import lang::java::m3::Core;
import org::maracas::io::File;
import String;


@memo
M3 projectM3(loc project) {
	if(existFileWithName(project, "pom.xml") 
		|| existFileWithName(project, "MANIFEST.MF")) {

		//TODO: make it parametric 
		classPaths = getClassPath(project, mavenExecutable=|file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|);
		classPath = [*classPaths[cp] | cp <- classPaths];
		
		// THis step seems to take too long
		return createM3FromFiles(project,
			fetchFilesByExtension(project, "java"),
			sourcePath=[project],
			classPath=classPath);
	}
	else {
		return createM3FromDirectory(project);
	}
}

private set[loc] fetchFilesByExtension(loc directory, str extension) {
	set[loc] files = {};
	if(isDirectory(directory)) {
		for(f <- directory.ls) {
			if(isDirectory(f)) {
				files += fetchFilesByExtension(f, extension);
			}
			if(isFile(f) && endsWith(f.path, ".<extension>")) {
				files += f;
			}
		}
	}
	return files;
}