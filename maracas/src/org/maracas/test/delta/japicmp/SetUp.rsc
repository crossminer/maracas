module org::maracas::\test::delta::japicmp::SetUp

import org::maracas::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

public loc apiOld = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-old.jar|;
public loc apiNew = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-new.jar|;

public M3 m3ApiOld = createM3(apiOld);
public M3 m3ApiNew = createM3(apiNew);

// From JAR
public loc client = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-client.jar|;
public M3 m3Client = createM3(client, classPath = [apiOld]);

// From sources
//public loc client = |file:///home/dig/repositories/maracas/data/comp-changes-client/src|;
//public M3 m3Client = createM3FromSources(client, classPath = [apiOld]);

public list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
public Evolution evol = createEvolution(m3Client, m3ApiOld, m3ApiNew, delta);
public set[Detection] detects = computeDetections(evol);

public loc detectsLoc = |project://maracas/src/org/maracas/test/data/delta/detects.bin|;
public loc evolLoc = |project://maracas/src/org/maracas/test/data/delta/evol.bin|;