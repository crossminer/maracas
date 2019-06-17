module org::maracas::Maracas

import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::delta::DeltaBuilder;
import org::maracas::delta::Detector;
import org::maracas::delta::Migration;
import org::maracas::m3::Core;


Delta delta(loc oldAPI, loc newAPI) 
	= createDelta(createM3(oldAPI), createM3(newAPI));

Delta classDelta(Delta delta)
	= getClassDelta(delta);

Delta methodDelta(Delta delta)
	= getMethodDelta(delta);
	
Delta fieldDelta(Delta delta)
	= getFieldDelta(delta);
	
set[Detection] detections(loc client, Delta delta) 
	= detections(createM3(client), delta);
	
set[Migration] migrations(loc newClient, set[Detection] detects)
	= buildMigrations(detects, newClient);
