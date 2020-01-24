module org::maracas::\test::delta::japicmp::SetUp

import lang::java::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

loc apiOld = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-old.jar|;
loc apiNew = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-new.jar|;
loc client = |file:///Users/ochoa/Documents/cwi/crossminer/code/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-client.jar|;

public M3 m3ApiOld = createM3FromJar(apiOld);
public M3 m3ApiNew = createM3FromJar(apiNew);
public M3 m3Client = createM3FromJar(client);

public list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
public Evolution evol = createEvolution(m3Client, m3ApiOld, m3ApiNew, delta);
public set[Detection] detects = detections(evol);

public loc detectsLoc = |project://maracas/src/org/maracas/test/data/delta/detects.bin|;
public loc evolLoc = |project://maracas/src/org/maracas/test/data/delta/evol.bin|;