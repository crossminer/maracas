module org::maracas::groundtruth::Groundtruth

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
import org::maracas::groundtruth::MessageMatcher;
import org::maracas::groundtruth::Report;
import org::maracas::io::File;
import org::maracas::m3::ClassPaths;
import org::maracas::measure::delta::Evolution;

import lang::csv::IO;
import lang::java::m3::Core;

import IO;
import List;
import Map;
import Relation;
import Set;
import String;
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

void main() {
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

void runGroundtruth(loc clientsCsv = |file:///Users/ochoa/Documents/cwi/crossminer/data/deltas/clients.csv|, loc deltasDir = |file:///Users/ochoa/Documents/cwi/crossminer/data/deltas/deltas|) {
	// You can get the rq2-clients-clean.csv at https://github.com/tdegueul/maven-api-dataset/blob/master/notebooks/rq2-clients-clean.csv
	println("Loading clients CSV...");
	clients = readCSV(#rel[int id, str group, str artifact, str version, str cgroup, str cartifact, str cversion, bool external, int cjava_version, int cdeclarations, int capideclarations], clientsCsv);

	// Pre-computed map of the deltas we should look at to cover all kinds of BC
	map[CompatibilityChange, loc] deltas = (
	  methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.seleniumhq.selenium/selenium-firefox-driver/2.46.0_to_2.47.0.delta",
	  methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.springframework/spring-jdbc/5.0.2.RELEASE_to_5.0.3.RELEASE.delta",
	  methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.neo4j/neo4j-udc/1.8.M07_to_1.8.RC1.delta",
	  classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.openehealth.ipf.platform-camel/ipf-platform-camel-hl7/3.4.2_to_3.5-20180302.delta",
	  interfaceAdded(binaryCompatibility=true,sourceCompatibility=true) : deltasDir + "org.apache.cxf/cxf-rt-ws-addr/3.0.0-milestone2_to_3.0.1.delta",
	  fieldNowStatic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.springframework/spring-core/2.0.6_to_2.0.7.delta",
	  methodRemoved(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-http/8.1.5.v20120716_to_8.1.6.v20120903.delta",
	  methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false) : deltasDir + "org.apache.camel/camel-flatpack/2.16.1_to_2.16.2.delta",
	  fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.apache.solr/solr-core/3.3.0_to_3.4.0.delta",
	  superclassAdded(binaryCompatibility=true,sourceCompatibility=true) : deltasDir + "org.apache.cxf/cxf-rt-ws-policy/3.1.9_to_3.1.10.delta",
	  methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-jmx/9.4.8.v20171121_to_9.4.9.v20180320.delta",
	  fieldMoreAccessible(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-http/8.1.0.v20120127_to_8.1.1.v20120215.delta",
	  fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.springframework/spring-jdbc/5.0.3.RELEASE_to_5.0.4.RELEASE.delta",
	  classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false) : deltasDir + "org.drools/drools-compiler/6.1.0.Beta2_to_6.1.0.Beta3.delta",
	  superclassRemoved(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "io.gravitee.gateway/gravitee-gateway-env/1.13.3_to_1.14.0.delta",
	  methodNowStatic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.neo4j/neo4j-udc/2.1.0-RC2_to_2.1.0.delta",
	  classNowFinal(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.apache.cxf/cxf-rt-ws-addr/2.1.8_to_2.1.9.delta",
	  methodIsStaticAndOverridesNotStatic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.scala-js/scalajs-library_2.12.0-M2/0.6.4_to_0.6.5.delta",
	  methodNewDefault(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-io/9.3.9.v20160517_to_9.3.10.M0.delta",
	  classTypeChanged(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "io.dropwizard.metrics/metrics-core/4.0.0_to_4.0.1.delta",
	  methodAbstractAddedInImplementedInterface(binaryCompatibility=true,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-jmx/9.4.3.v20170317_to_9.4.4.v20170414.delta",
	  annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true) : deltasDir + "org.eclipse.jetty/jetty-http/9.4.0.v20180619_to_9.4.1.v20180619.delta",
	  fieldLessAccessibleThanInSuperclass(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.apache.solr/solr-core/4.0.0-BETA_to_4.0.0.delta",
	  methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.apache.santuario/xmlsec/2.0.1_to_2.0.2.delta",
	  methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "io.fabric8/fabric8-cxf/2.2.115_to_2.2.122.delta",
	  methodNowFinal(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "com.typesafe.akka/akka-actor_2.11/2.4.12_to_2.4.13.delta",
	  classNowAbstract(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.apache.cxf/cxf-rt-management/2.6.16_to_2.7.13.delta",
	  fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-io/9.1.0.RC1_to_9.1.0.RC2.delta",
	  methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "io.fabric8/openshift-client/1.3.78_to_1.3.79.delta",
	  constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-http/9.4.0.M1_to_9.4.0.RC0.delta",
	  fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "io.gravitee.gateway/gravitee-gateway-env/1.0.1_to_1.4.0.delta",
	  methodAbstractAddedToClass(binaryCompatibility=true,sourceCompatibility=false) : deltasDir + "io.dropwizard.metrics/metrics-core/3.1.1_to_3.1.2.delta",
	  methodAbstractAddedInSuperclass(binaryCompatibility=true,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-io/9.0.0.M2_to_9.0.0.M3.delta",
	  fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.apache.camel/camel-http/2.16.1_to_2.16.2.delta",
	  classRemoved(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-io/9.3.5.v20151012_to_9.3.6.v20151106.delta",
	  methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false) : deltasDir + "org.eclipse.jetty/jetty-http/7.5.0.RC1_to_7.5.0.RC2.delta",
	  interfaceRemoved(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "io.ultreia.java4all.i18n/i18n-api/4.0-alpha-6_to_4.0-alpha-9.delta",
	  classLessAccessible(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.openehealth.ipf.platform-camel/ipf-platform-camel-hl7/3.4.2_to_3.5-20180302.delta",
	  fieldStaticAndOverridesStatic(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.pac4j/pac4j-oauth/3.0.1_to_3.1.0.delta",
	  fieldRemoved(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "org.scala-lang/scala-compiler/2.9.0.RC5_to_2.9.0-1.delta",
	  constructorRemoved(binaryCompatibility=false,sourceCompatibility=false) : deltasDir + "com.netflix.eureka/eureka-client/1.8.7_to_1.9.2.delta"
	);
	loc homeDir = getUserHomeDir();

	set[loc] allClients = {};
	// For all deltas, get the JARs of libV1/libV2/client, and compare Maracas against the GT
	for (CompatibilityChange cc <- deltas) {
		loc deltaLoc = deltas[cc];
		list[APIEntity] delta = readBinaryValueFile(#list[APIEntity], deltaLoc);
		println("Analyzing a delta containing <numberChanges(delta)> BCs [for <cc>]");

		str group = deltaLoc.parent.parent.file;
		str artifact = deltaLoc.parent.file;

		// Help, I don't know how to match a regex without having to use an if :(
		if (/^<v1:.*>_to_<v2:.*>.delta$/ := deltaLoc.file) {
			loc jarV1 = downloadJar(group, artifact, v1);
			loc jarV2 = downloadJar(group, artifact, v2);

			println("Loading M3s of the library");
			M3 m3V1 = createM3FromJar(jarV1, classPath = []); // FIXME: classpath
			M3 m3V2 = createM3FromJar(jarV2, classPath = []); // FIXME: classpath

			// Find clients using group:artifact:v1
			for (<_, group, artifact, v1, cg, ca, cv, _, _, _, _> <- clients) {
				loc client = downloadJar(cg, ca, cv);
				loc clientSrc = downloadSrcs(cg, ca, cv);
				loc clientDir = clientSrc;
				clientDir.path = replaceLast(clientDir.path, ".<clientDir.extension>", "");
				
				bool upgraded = upgradeClient(client, clientDir, group, artifact, v1, v2);
				println("Client upgraded: <upgraded>");
				
				if (upgraded) {
					println("Loading M3 of the client");
					map[loc, list[loc]] srcClasspath = getClassPath(clientDir, mavenExecutable = |file:///Users/ochoa/installations/apache-maven-3.5.4|);
					
					M3 clientM3 = createM3FromJar(client, classPath = []); // FIXME: classpath
					M3 clientSrcM3 = createM3FromDirectory(clientDir, classPath = range(srcClasspath), javaVersion="1.8"); // FIXME: classpath
					
					generateReport(homeDir + "tmp/gt/reports/<group>:<artifact>:<v1>_to_<v2>:<cg>:<ca>:<cv>.txt", m3V1, m3V2, clientM3, clientSrcM3, delta);
					allClients += client;
				}
			}
		}
	}

	println(clients);
	println(size(allClients));
}
