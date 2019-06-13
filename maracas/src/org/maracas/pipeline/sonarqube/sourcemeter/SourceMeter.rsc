module org::maracas::pipeline::sonarqube::sourcemeter::SourceMeter

import Exception;
import IO;

import org::maracas::delta::Delta;
import org::maracas::delta::Detector;
import org::maracas::pipeline::sonarqube::Pipeline;

loc dataLoc = |project://maracas/src/org/maracas/pipeline/sonarqube/sourcemeter/data|;


void runAll() {
	Delta delt = computeDeltaSonar();
	computeStatisticsSonar(delt, "stats-delta.csv");
	Delta bc = computeBreakingChangesSonar(delt);
	computeStatisticsSonar(bc, "stats-bc.csv");
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
	return computeStatistics(delt, output=output);
}

public loc unzipSourceMeter(loc sourcemeter) {
    tempLoc = dataLoc + "temp/sourcemeter";
    zip = sourcemeter[scheme = "jar+<sourcemeter.scheme>"][path = sourcemeter.path + "!/"];
    
    if (copyDirectory(zip, tempLoc)) {
        return tempLoc;
    }
    
    throw IO("Could not copy content of <sourcemeter> to <tempLoc>");
}

set[Detection] computeDetections() {
	loc sourcemeterv1 = dataLoc + "";
	loc output = dataLoc + "detections.bin";
	return computeDetections();
}