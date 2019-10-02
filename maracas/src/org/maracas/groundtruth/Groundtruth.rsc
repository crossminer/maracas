module org::maracas::groundtruth::Groundtruth

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
