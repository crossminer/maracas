module org::maracas::\test::delta::jezek_benchmark::SetUp

import org::maracas::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

public loc apiOld = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/jezek-lib-v1.jar|;
public loc apiNew = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/jezek-lib-v2.jar|;

public M3 m3ApiOld = createM3(apiOld);
public M3 m3ApiNew = createM3(apiNew);

// From JAR
public loc client = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/jezek-client.jar|;
public M3 m3Client = createM3(client);

// From sources
//public loc client = |file:///home/dig/repositories/api-evolution-data-corpus/client/src|;
//public M3 m3Client = createM3FromSources(client, classPath = [apiOld]);

public list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
public Evolution evol = createEvolution(m3Client, m3ApiOld, m3ApiNew, delta);
public set[Detection] detects = computeDetections(evol);
