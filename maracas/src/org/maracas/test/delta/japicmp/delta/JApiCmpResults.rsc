module org::maracas::\test::delta::japicmp::delta::JApiCmpResults

import org::maracas::delta::JApiCmp;


@javaClass{org.maracas.test.delta.japicmp.delta.internal.JApiCmpResults}
@reflect{for debugging}
java int getNumClasses(str apiOld, str apiNew);

@javaClass{org.maracas.test.delta.japicmp.delta.internal.JApiCmpResults}
@reflect{for debugging}
java map[str, list[str]] getChangesPerClassJApi(str apiOld, str apiNew);

map[str, list[str]] getChangesPerClassMaracas(list[APIEntity] delta) {
	map[str, list[str]] res = ();
	for (APIEntity e <- delta) {
		str name = e.id.path;
		list[str] changes = [ "<c>" | CompatibilityChange c <- e.changes ];
		res += (name : changes);
	}
	return res;
}