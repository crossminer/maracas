module org::maracas::groundtruth::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::groundtruth::MessageMatcher;
import org::maracas::groundtruth::Report;
import org::maracas::io::File;
import org::maracas::m3::ClassPaths;
import org::maracas::measure::delta::Evolution;

import lang::csv::IO;
import lang::java::m3::AST;
import lang::java::m3::Core;

import IO;
import List;
import Map;
import Relation;
import Set;
import String;
import util::FileSystem;
import ValueIO;

/**
 * TODOs/FIXMEs
 *
 *   - Maven error message parsing is extremely brittle
 *   - Overrides the client's configuration if it already uses one of these two plugins:
 *      + maven-dependency-plugin
 *      + build-helper-maven-plugin
 *      + maven-compiler-plugin
 *      + (which is very likely ;)
 *      + (and will break stuff)
 *   - javac reports 100 errors max. Could be fixed with the -Xmaxerrs/-Xmaxwarns flags
 */

void runArtifGroundtruth() {
	loc homeDir = getUserHomeDir();
	loc oldApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.1/comp-changes-0.0.1.jar";
	loc newApi = homeDir + ".m2/repository/maracas-data/comp-changes/0.0.2/comp-changes-0.0.2.jar";
	loc client = homeDir + ".m2/repository/maracas-data/comp-changes-client/0.0.1/comp-changes-client-0.0.1.jar";
	
	loc clientDir = homeDir + "temp/maracas/comp-changes-client-0.0.1.jar";
	//loc srcClient = clientDir + "target/extracted-sources";
	loc srcClient = clientDir + "";
	loc clientPom = clientDir + "pom.xml";
	loc javacReport = clientDir + "report/comp-changes-javac.txt";
	loc jdtReport = clientDir + "report/comp-changes-jdt.txt";
	
	println("Upgrading client project");
	bool upgraded = upgradeClient(client, clientDir, "maracas-data", "comp-changes", "0.0.1", "0.0.2");
	println("Client upgraded: <upgraded>");
	
	println("Computing M3 models");
	M3 oldM3 = createM3FromJar(oldApi);
	M3 newM3 = createM3FromJar(newApi);
	M3 clientM3 = createM3FromJar(client);
	M3 sourceM3 = createM3FromDirectory(srcClient, javaVersion="1.8");
	list[APIEntity] delta = compareJars(oldApi, newApi, "0.0.1", "0.0.2");
	
	generateReport(jdtReport, oldM3, newM3, clientM3, sourceM3, delta);
}

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{for debugging}
java loc downloadJar(str group, str artifact, str version);

@javaClass{org.maracas.groundtruth.internal.Groundtruth}
@reflect{for debugging}
java loc downloadSrcs(str group, str artifact, str version);

set[CompatibilityChange] getGroundtruthCCs() 
	= {
		methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false), 
		methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false), 
		methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false), 
		classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false), 
		interfaceAdded(binaryCompatibility=true,sourceCompatibility=true), 
		fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false), 
		methodRemoved(binaryCompatibility=false,sourceCompatibility=false), 
		methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false), 
		fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false), 
		superclassAdded(binaryCompatibility=true,sourceCompatibility=true), 
		methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false), 
		fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false), 
		fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false), 
		classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false), 
		superclassRemoved(binaryCompatibility=false,sourceCompatibility=false), 
		methodNowStatic(binaryCompatibility=false,sourceCompatibility=false), 
		classNowFinal(binaryCompatibility=false,sourceCompatibility=false), 
		methodNewDefault(binaryCompatibility=false,sourceCompatibility=false),
		classTypeChanged(binaryCompatibility=false,sourceCompatibility=false), 
		annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true), 
		methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false), 
		methodNowFinal(binaryCompatibility=false,sourceCompatibility=false), 
		classNowAbstract(binaryCompatibility=false,sourceCompatibility=false), 
		fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false),
		methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false),
		constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false),
		fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false),
		methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false),
		classRemoved(binaryCompatibility=false,sourceCompatibility=false),
		methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false),
		interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false),
		classLessAccessible(binaryCompatibility=false,sourceCompatibility=false),
		fieldRemoved(binaryCompatibility=false,sourceCompatibility=false),
		constructorRemoved(binaryCompatibility=false,sourceCompatibility=false)
		//methodIsStaticAndOverridesNotStatic(binaryCompatibility=false,sourceCompatibility=false), //PERMANENT
		//methodAbstractAddedInImplementedInterface(binaryCompatibility=true,sourceCompatibility=false), //PERMANENT
		//methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false), //PERMANENT
		//methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false), //PERMANENT
		//fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false), //PERMANENT
		//fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false), //PERMANENT
		//fieldLessAccessibleThanInSuperclass(binaryCompatibility=false,sourceCompatibility=false) //PERMANENT
	};
	
rel[loc, int, int] getDeltaStats(loc deltasDir, CompatibilityChange cc, loc clientsCsv) {
	clients = readCSV(#rel[str group, str artifact, str version, str cgroup, str cartifact, str cversion, bool external, int cjava_version, int cdeclarations, int capideclarations], clientsCsv);
	rel[str, str, str] usedDeltas = clients<0, 1, 2>;
	rel[loc, int, int] stats = {};
	
	for (<str g, str a, str v> <- usedDeltas) {
		loc currentDir = deltasDir + "<g>/<a>";
		if (exists(currentDir)) {
			println(currentDir);
			
			for (loc l <- currentDir.ls, startsWith(l.file, "<v>")) {
				list[APIEntity] delta = readBinaryValueFile(#list[APIEntity], l);
				stats += <l, numberChangesPerType(delta, cc), numberChanges(delta)> ;
			}
		}
	}
	
	return stats;
}

// <location, numberChangesPerType, numberChanges>
lrel[loc, int, int] orderDeltas(CompatibilityChange cc, loc clientsCsv, loc deltasDir, loc file) {
	rel[loc, int, int] stats = getDeltaStats(deltasDir, cc, clientsCsv);
	rel[int, int, loc] statsInv = invert(stats);
	lrel[loc, int, int] orderedDeltas = [];
	list[int] ccValues = sort(stats<2>);
	
	for (int ccVal <- ccValues, ccVal != 0) {
		list[int] bcsValues = sort(stats[_, ccVal]);
		
		for (int bcsVal <- bcsValues) {
			set[loc] currentDeltas = statsInv[bcsVal, ccVal];
			orderedDeltas += [ <d, ccVal, bcsVal> | loc d <- currentDeltas ];
		}
	}
	writeCSV(orderedDeltas, file);
	return orderedDeltas;
}

void runMavenGroundtruth(loc clientsCsv = |file:///Users/ochoa/Documents/cwi/crossminer/data/deltas/clients.csv|, loc deltasDir = |file:///Users/ochoa/Documents/cwi/crossminer/data/deltas/deltas|, loc mavenExecutable = |file:///Users/ochoa/installations/apache-maven-3.5.4/bin/mvn|) {
	// You can get the rq2-clients-clean.csv at https://github.com/tdegueul/maven-api-dataset/blob/master/notebooks/rq2-clients-clean.csv
	println("Loading clients CSV...");
	clients = readCSV(#rel[str group, str artifact, str version, str cgroup, str cartifact, str cversion, bool external, int cjava_version, int cdeclarations, int capideclarations], clientsCsv);
	set[CompatibilityChange] ccs = getGroundtruthCCs();
	loc homeDir = getUserHomeDir();

	// For all deltas, get the JARs of libV1/libV2/client, and compare Maracas against the GT
	for (CompatibilityChange cc <- ccs) {
		loc deltasCsv = homeDir + "tmp/gt/<cc>/orderedDeltas.csv";
		lrel[loc, int, int] deltas = (exists(deltasCsv)) 
			? readCSV(#lrel[loc, int, int], deltasCsv) 
			: orderDeltas(cc, clientsCsv, deltasDir, homeDir + "tmp/gt/<cc>/orderedDeltas.csv");
		bool hasReport = false;
		
		for (<loc l, int b, int c> <- deltas, !hasReport) {
			list[APIEntity] delta = readBinaryValueFile(#list[APIEntity], l);
			str group = l.parent.parent.file;
			str artifact = l.parent.file;
			
			// Help, I don't know how to match a regex without having to use an if :(
			if (/^<v1:.*>_to_<v2:.*>.delta$/ := l.file) {
				println("Analyzing a delta containing <numberChanges(delta)> BCs [for <cc>]: <group>:<artifact>:<v1> to <v2>");
				
				loc jarV1 = downloadJar(group, artifact, v1);
				loc jarV2 = downloadJar(group, artifact, v2);
				
				try {
					println("Loading M3s of the library");
					M3 m3V1 = createM3FromJar(jarV1, classPath = []); // FIXME: classpath
					M3 m3V2 = createM3FromJar(jarV2, classPath = []); // FIXME: classpath
					
					// Find clients using group:artifact:v1
					for (<group, artifact, v1, cg, ca, cv, _, _, _, _> <- clients) {
						println("<cg> <ca> <cv>");
						try {
							loc client = downloadJar(cg, ca, cv);
							loc clientSrc = downloadSrcs(cg, ca, cv);
							loc clientDir = homeDir + "tmp/gt/<cc>/srcs/<replaceLast(clientSrc.file, ".<clientSrc.extension>", "")>";
							loc hasReport = false;
							
							bool upgraded = upgradeClient(client, clientDir, group, artifact, v1, v2);
							println("Client upgraded: <upgraded>");
							
							if (upgraded) {
								println("Loading M3 of the client");
								set[loc] srcPaths = getPaths(clientDir, "java");
								set[loc] srcFiles = { p | loc sp <- srcPaths, loc p <- find(sp, "java"), isFile(p)};
								map[loc, list[loc]] mapClasspath = getClassPath(clientDir, mavenExecutable = mavenExecutable);
								list[loc] srcClasspath = [ *mapClasspath[cp] | loc cp <- mapClasspath ];
									
								M3 clientM3 = createM3FromJar(client, classPath = srcClasspath);
								M3 clientSrcM3 = composeJavaM3(clientDir, createM3sFromFiles(srcFiles, sourcePath = [ *findRoots(srcPaths) ], classPath = srcClasspath, javaVersion = "1.8"));
								
								println("Computing evolution models");
								Evolution evol = createEvolution(clientM3, oldM3, newM3, delta);
								set[Detection] detects = detections(evol); 
								
								bool hasCCDetect = false;
								for (Detection d <- detects) {
									if (d.change == cc) {
										hasCCDetect = true;
										break;
									}
								}
								
								hasReport = (hasCCDetect) ? generateReport(homeDir + "tmp/gt/<cc>/reports/<group>_<artifact>_<v1>_to_<v2>_<cg>_<ca>_<cv>.txt", evol, detects, clientSrcM3) : false;
							}
							
							if (hasReport) {
								println("Found report for <group>_<artifact>_<v1>_to_<v2>_<cg>_<ca>_<cv>");
								break;
							}
							else {
								deleteDir(clientDir);
							}
						}
						catch e: {
							continue; // Just skip if there are no client sources or if the project cannot compile.
						}
					}
				}
				catch : {
					continue; // Skip
				}
			}
		}
	}
}
