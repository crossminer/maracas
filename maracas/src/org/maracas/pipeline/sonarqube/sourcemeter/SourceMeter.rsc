module org::maracas::pipeline::sonarqube::sourcemeter::SourceMeter

import org::maracas::delta::Delta;
import org::maracas::delta::Detector;
import org::maracas::delta::Migration;
import org::maracas::io::File;
import org::maracas::pipeline::sonarqube::Pipeline;

loc dataLoc = |project://maracas/src/org/maracas/pipeline/sonarqube/sourcemeter/data|;


void runAll() {
	Delta delt = computeDeltaSonar();
	computeStatisticsSonar(delt, "stats-delta.csv");
	Delta bc = computeBreakingChangesSonar(delt);
	computeStatisticsSonar(bc, "stats-bc.csv");
	set[Detection] detects = computeDetectionsSonarJar(bc);
	computeStatisticsSonar(detects, "stats-detections.csv");
	set[Migration] migs = computeMigrationsSonar(detects);
}

Delta computeDeltaSonar(bool store = true, bool rewrite = false) {
	loc sonarv1 = dataLoc + "sonar-plugin-api-4.2.jar";
	loc sonarv2 = dataLoc + "sonar-plugin-api-6.7.jar";
	loc output = dataLoc + "delta.bin";
	
	return computeDelta(sonarv1, sonarv2, output=output, store=store, rewrite=rewrite);
}

Delta computeBreakingChangesSonar(Delta delt, bool store = true, bool rewrite = false) {
	loc output = dataLoc + "bc.bin";
	return computeBreakingChanges(delt, output=output, store=store, rewrite=rewrite);
}

rel[str, int] computeStatisticsSonar(Delta delt, str fileName) {
	loc output = dataLoc + fileName;
	return computeDeltaStatistics(delt, output=output);
}

set[Detection] computeDetectionsSonarJar(Delta delt, bool store = true, bool rewrite = false) {
	loc sourcemeterv1 = dataLoc + "sonar-sourcemeter-analyzer-java-plugin-8.2.jar";
	loc output = dataLoc + "detections.bin";
	
	return computeDetections(sourcemeterv1, delt, output=output, store=store, rewrite=rewrite);
}

rel[str, int] computeStatisticsSonar(set[Detection] detects, str fileName) {
	loc output = dataLoc + fileName;
	return computeDetectionsStatistics(detects, output=output);
}

set[Migration] computeMigrationsSonar(set[Detection] detects, bool store = true, bool rewrite = false) {
	loc sourcemeterv2 = dataLoc + "sonar-sourcemeter-analyzer-java-plugin-8.2-v6.7.1.jar";
	loc output = dataLoc + "migrations.bin";
	
	return computeMigrations(sourcemeterv2, detects, output=output, store=store, rewrite=rewrite);
}

//TODO: errors with Maven
set[Detection] computeDetectionsSonarSource(Delta delt, bool store = true, bool rewrite = false) {
	loc sourcemeterv1 = dataLoc + "sourcemeter-plugins-8.2-sources.zip";
	loc output = dataLoc + "detections.bin";
	loc targetDir = dataLoc + "temp/";
	
	sourcemeterv1 = unzipFile(sourcemeterv1, targetDir);
	return computeDetections(sourcemeterv1, delt, output=output, store=store, rewrite=rewrite);
}