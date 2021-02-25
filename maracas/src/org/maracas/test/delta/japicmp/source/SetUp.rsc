module org::maracas::\test::delta::japicmp::source::SetUp

import org::maracas::m3::Core;
import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;

public loc apiOld = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-old.jar|;
public loc apiNew = |file:///home/dig/repositories/maracas/maracas/src/org/maracas/test/data/delta/comp-changes-new.jar|;
public loc client = |file:///home/dig/repositories/maracas/data/comp-changes-client/src|;

public M3 m3ApiOld = createM3(apiOld);
public M3 m3ApiNew = createM3(apiNew);

public M3 m3Client = createM3FromSources(client, classPath = [apiOld]);

public list[APIEntity] delta = compareJars(apiOld, apiNew, "0.0", "1.0");
public Evolution evol = createEvolution(m3Client, m3ApiOld, m3ApiNew, delta);
public set[Detection] detects = computeDetections(evol);
