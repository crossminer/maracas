module org::maracas::Maracas

import lang::java::m3::Core;
import org::maracas::delta::Delta;
import org::maracas::delta::DeltaBuilder;
import org::maracas::delta::Detector;
import org::maracas::delta::Migration;
import org::maracas::m3::Core;
import ValueIO;


Delta delta(loc oldAPI, loc newAPI) 
	= createDelta(createM3(oldAPI), createM3(newAPI));

Delta classDelta(Delta delta)
	= getClassDelta(delta);

Delta methodDelta(Delta delta)
	= getMethodDelta(delta);
	
Delta fieldDelta(Delta delta)
	= getFieldDelta(delta);
	
bool storeDelta(loc m3OldAPI, loc m3NewAPI, loc delt) {
	try {
		M3 oldM3 = readBinaryValueFile(#M3, m3OldAPI);
		M3 newM3 = readBinaryValueFile(#M3, m3NewAPI);
		
		Delta d = createDelta(oldM3, newM3);
		writeBinaryValueFile(delt, d);
		return true;
	}
	catch :
		return false;
}
	
set[Detection] detections(loc oldClient, Delta delta) 
	= detections(createM3(oldClient), delta);
	
set[Migration] migrations(loc newClient, set[Detection] detects)
	= migrations(newClient, detects);
	
