module org::maracas::Maracas

import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::delta::DeltaBuilder;
import org::maracas::delta::Detector;
import org::maracas::m3::Core;


Delta classDelta(loc oldAPI, loc newAPI) 
	= delta(oldAPI, newAPI, createClassDelta);
	
Delta methodDelta(loc oldAPI, loc newAPI) 
	= delta(oldAPI, newAPI, createMethodDelta);
	
Delta fieldDelta(loc oldAPI, loc newAPI) 
	= delta(oldAPI, newAPI, createFieldDelta);

private Delta delta(loc oldAPI, loc newAPI, Delta (M3, M3) fun) 
	= fun(m3(oldAPI), m3(newAPI));


set[Detection] detections(loc client, Delta delta) 
	= detections(m3(client), delta);