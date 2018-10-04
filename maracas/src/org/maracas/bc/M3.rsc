module org::maracas::bc::M3

import lang::java::m3::ClassPaths;
import lang::java::m3::Core;
import org::maracas::io::File;


M3 projectM3(loc project) {
	if(existFileWithName(project, "pom.xml") 
		|| existFileWithName(project, "MANIFEST.MF")) {
		classPaths = getClassPath(project);
		
		//We assume that mavenExecutable=|file:///usr/local/bin/mvn|
		return createM3FromFiles(project,
			fetchFilesByExtension(project, "java"),
			sourcePath=[project],
			classPath=[*classPaths[cp] | cp <- classPaths]);
	}
	else {
		return createM3FromDirectory(project);
	}
}