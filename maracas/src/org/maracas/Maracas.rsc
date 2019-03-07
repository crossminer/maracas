module org::maracas::Maracas

import lang::java::m3::Core;
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::Detector;
import org::maracas::bc::M3;


BreakingChanges classBreakingChanges(loc oldAPI, loc newAPI) 
	= breakingChanges(oldAPI, newAPI, createClassBC);
	
BreakingChanges methodBreakingChanges(loc oldAPI, loc newAPI) 
	= breakingChanges(oldAPI, newAPI, createMethodBC);
	
BreakingChanges fieldBreakingChanges(loc oldAPI, loc newAPI) 
	= breakingChanges(oldAPI, newAPI, createFieldBC);

private BreakingChanges breakingChanges(loc oldAPI, loc newAPI, BreakingChanges (M3, M3) fun) 
	= fun(m3(oldAPI), m3(newAPI));


list[Detection] detections(loc client, BreakingChanges bc) 
	= detections(projectM3(client), bc);