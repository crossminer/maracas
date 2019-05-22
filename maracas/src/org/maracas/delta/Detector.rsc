module org::maracas::delta::Detector

import IO;
import lang::java::m3::Core;
import org::maracas::delta::Delta;
import Relation;


//----------------------------------------------
// ADT
//----------------------------------------------

data Detection = detection (
	loc jar,
	loc elem,
	loc used,
	Mapping[&T] mapping, 
	DeltaType typ
);

data DeltaType
	= accessModifiers()
	| finalModifiers()
	| staticModifiers()
	| abstractModifiers()
	| paramLists()
	| types()
	| extends()
	| implements()
	| deprecated()
	| renamed()
	| moved()
	| removed()
	;
	

//----------------------------------------------
// Builder
//----------------------------------------------

set[Detection] detections(M3 client, Delta delta)
	= detectionsCore(client, delta);
	
private set[Detection] detectionsCore(M3 client, Delta delta)
	= detections(client, delta, accessModifiers())
	+ detections(client, delta, finalModifiers())
	+ detections(client, delta, staticModifiers())
	+ detections(client, delta, abstractModifiers())
	+ detections(client, delta, paramLists())
	+ detections(client, delta, types())
	+ detections(client, delta, extends())
	+ detections(client, delta, implements())
	+ detections(client, delta, deprecated())
	+ detections(client, delta, renamed())
	+ detections(client, delta, moved())
	//+ detections(client, delta, removed())
	;

private set[Detection] detections(M3 client, Delta delta, accessModifiers()) 
	= detections(client, delta.accessModifiers, accessModifiers());

private set[Detection] detections(M3 client, Delta delta, finalModifiers()) 
	= detections(client, delta.finalModifiers, finalModifiers());

private set[Detection] detections(M3 client, Delta delta, staticModifiers()) 
	= detections(client, delta.staticModifiers, staticModifiers());

private set[Detection] detections(M3 client, Delta delta, abstractModifiers()) 
	= detections(client, delta.abstractModifiers, abstractModifiers());

private set[Detection] detections(M3 client, Delta delta, deprecated()) 
	= detections(client, delta.deprecated, deprecated());

private set[Detection] detections(M3 client, Delta delta, renamed()) 
	= detections(client, delta.renamed, renamed());
	
private set[Detection] detections(M3 client, Delta delta, moved()) 
	= detections(client, delta.moved, moved());

private set[Detection] detections(M3 client, Delta delta, removed()) 
	= detections(client, delta.removed, removed());

private set[Detection] detections(M3 client, Delta delta, extends()) 
	= detections(client, delta.extends, extends());
	
private set[Detection] detections(M3 client, Delta delta, implements()) 
	= detections(client, delta.implements, implements());
	
private set[Detection] detections(M3 client, Delta delta, paramLists()) 
	= detections(client, delta.paramLists, paramLists());

private set[Detection] detections(M3 client, Delta delta, types()) 
	= detections(client, delta.types, types());
		
private set[Detection] detections(M3 client, rel[loc, Mapping[&T]] deltaRel, DeltaType typ) {	
	set[loc] domain = domain(deltaRel);
	uses = rangeR(client.typeDependency, domain)
		+ rangeR(client.methodInvocation, domain)
		+ rangeR(client.fieldAccess, domain)
		+ rangeR(client.implements, domain)
		+ rangeR(client.extends, domain);
		
	return { detection(client.id, elem, used, mapping, typ) | <loc elem, loc used> <- uses, mapping <- deltaRel[used] };
}

bool isInDetections(loc elem, loc used, DeltaType typ, set[Detection] detections) {
	for (d <- detections) {
		if (detection(_, elem, used, _, typ) := d) {
			return true;
		}
	}
	return false;
}