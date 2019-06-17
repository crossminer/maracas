module org::maracas::Maracas

import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::delta::DeltaBuilder;
import org::maracas::delta::Detector;
import org::maracas::delta::Migration;
import org::maracas::m3::Core;


Delta delta(loc oldAPI, loc newAPI) 
	= createDelta(m3(oldAPI), m3(newAPI));

Delta classDelta(Delta delta)
	= getClassDelta(delta);

Delta methodDelta(Delta delta)
	= getMethodDelta(delta);
	
Delta fieldDelta(Delta delta)
	= getFieldDelta(delta);
	
set[Detection] detections(loc oldClient, Delta delta) 
	= detections(m3(oldClient), delta);
	
set[Migration] migrations(loc newClient, set[Detection] detects)
	= buildMigrations(detects, newClient);