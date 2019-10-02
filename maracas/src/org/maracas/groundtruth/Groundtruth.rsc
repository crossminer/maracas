module org::maracas::groundtruth::Groundtruth

/**
 * TODOs/FIXMEs
 *
 *   - Maven error message parsing is extremely brittle
 *   - Breaks if the analyzed client already uses one of these two plugins:
 *      + maven-dependency-plugin
 *      + build-helper-maven-plugin
 *      + (which is likely ;)
 *   - javac reports 100 errors max. Could be fixed with the -Xmaxerrs/-Xmaxwarns flags
 */

data CompilerMessage = message(
	loc path,
	int line,
	int offset,
	str message,
	map[str, str] params
);

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{}
java list[CompilerMessage] recordErrors(loc clientJar, str groupId, str artifactId, str v1, str v2);
