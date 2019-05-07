module org::maracas::Maracas

import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::delta::DeltaBuilder;
import org::maracas::delta::Detector;
import org::maracas::m3::Core;


Delta delta(loc oldAPI, loc newAPI) 
	= createDelta(m3(oldAPI), m3(newAPI));

set[Detection] detections(loc client, Delta delta) 
	= detections(m3(client), delta);