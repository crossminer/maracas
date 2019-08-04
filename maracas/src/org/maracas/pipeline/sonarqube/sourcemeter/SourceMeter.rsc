module org::maracas::pipeline::sonarqube::sourcemeter::SourceMeter

import org::maracas::delta::Delta;
import org::maracas::delta::Detector;
import org::maracas::delta::Migration;
import org::maracas::io::File;
import org::maracas::pipeline::sonarqube::Pipeline;

loc dataLoc = |project://maracas/src/org/maracas/pipeline/sonarqube/sourcemeter/data|;


void runAll(bool runJavaClient = true, bool runCoreClient = true) {
	Delta delt = computeDeltaSonar();
	computeStatisticsSonar(delt, "stats-delta.csv");
	Delta bc = computeBreakingChangesSonar(delt);
	computeStatisticsSonar(bc, "stats-bc.csv");
	
	if (runJavaClient) {
		str javaClientV1 = "sonar-sourcemeter-analyzer-java-plugin-8.2";
		str javaClientV2 = "sonar-sourcemeter-analyzer-java-plugin-8.2-v6.7.1";
		str javaClientFolder = "analyzer-java";
		runClientPhases(bc, javaClientV1, javaClientV2, javaClientFolder);
	}
	
	if (runCoreClient) {
		str coreClientV1 = "sonar-sourcemeter-core-plugin-8.2";
		str coreClientV2 = "sonar-sourcemeter-core-plugin-8.2-v6.7.1";
		str coreClientFolder = "core";
		runClientPhases(bc, coreClientV1, coreClientV2, coreClientFolder);
	}
}

void runClientPhases(Delta delt, str fileNameV1, str fileNameV2, str folder) {
	set[Detection] detects = computeDetectionsSonarJar(delt, fileNameV1, folder);
	computeStatisticsSonar(detects, "<folder>/stats-detections.csv");
	
	Delta deltType = getClassDelta(delt);
	set[Detection] detectsTypes = computeDetectionsSonarJar(deltType, fileNameV1, folder, store=false, rewrite=true);
	computeStatisticsSonar(detectsTypes, "<folder>/stats-detections-types.csv");
	
	Delta deltMethod = getMethodDelta(delt);
	set[Detection] detectsMeths = computeDetectionsSonarJar(deltMethod, fileNameV1, folder, store=false, rewrite=true);
	computeStatisticsSonar(detectsMeths, "<folder>/stats-detections-method.csv");
	
	Delta deltField = getFieldDelta(delt);
	set[Detection] detectsFields = computeDetectionsSonarJar(deltField, fileNameV1, folder, store=false, rewrite=true);
	computeStatisticsSonar(detectsFields, "<folder>/stats-detections-field.csv");
	
	set[Migration] migs = computeMigrationsSonar(detects, fileNameV2, folder);
	computeStatisticsSonar(migs, "<folder>/stats-migrations.csv");
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

set[Detection] computeDetectionsSonarJar(Delta delt, str fileName, str folder, bool store = true, bool rewrite = false) {
	loc sourcemeterv1 = dataLoc + "<fileName>.jar";
	loc output = dataLoc + "<folder>/detections.bin";
	
	return computeDetections(sourcemeterv1, delt, output=output, store=store, rewrite=rewrite);
}

rel[str, int] computeStatisticsSonar(set[Detection] detects, str fileName) {
	loc output = dataLoc + fileName;
	return computeDetectionsStatistics(detects, output=output);
}

set[Migration] computeMigrationsSonar(set[Detection] detects, str fileName, str folder, bool store = true, bool rewrite = false) {
	loc sourcemeterv2 = dataLoc + "<fileName>.jar";
	loc output = dataLoc + "<folder>/migrations.bin";
	
	return computeMigrations(sourcemeterv2, detects, output=output, store=store, rewrite=rewrite);
}

rel[str, int, int, int] computeStatisticsSonar(set[Migration] migs, str fileName) {
	loc output = dataLoc + fileName;
	return computeMigrationsStatistics(migs, output=output);
}

//TODO: errors with Maven
set[Detection] computeDetectionsSonarSource(Delta delt, bool store = true, bool rewrite = false) {
	loc sourcemeterv1 = dataLoc + "sourcemeter-plugins-8.2-sources.zip";
	loc output = dataLoc + "detections.bin";
	loc targetDir = dataLoc + "temp/";
	
	sourcemeterv1 = unzipFile(sourcemeterv1, targetDir);
	return computeDetections(sourcemeterv1, delt, output=output, store=store, rewrite=rewrite);
}