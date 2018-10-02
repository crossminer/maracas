module org::swat::bc::Detector

import IO;
import lang::java::m3::Core;
import org::swat::bc::BreakingChanges;
import Relation;


//----------------------------------------------
// ADT
//----------------------------------------------

data Detection = detection (
	loc elem,
	loc used, 
	Mapping[&T,&U] mapping, 
	BCType typ
);

data BCType
	= changedAccessModifier()
	| changedFinalModifier()
	| moved()
	| removed()
	| renamed()
	| changedParamList()
	| changedReturnType()
	;
	

//----------------------------------------------
// Builder
//----------------------------------------------

list[Detection] detections(M3 client, BreakingChanges bc)
	= detectionsCore(client, bc) + detectionsExtra(client, bc);
	
private list[Detection] detectionsCore(M3 client, BreakingChanges bc)
	= detections(client, bc, changedAccessModifier())
	+ detections(client, bc, changedFinalModifier())
	+ detections(client, bc, moved())
	+ detections(client, bc, removed())
	+ detections(client, bc, renamed())
	;

private list[Detection] detectionsExtra(M3 client, BreakingChanges bc) {
	return switch (bc) {
		case \method(_): return detectionsExtraMethod(client, bc);
		default: return [];
	}
}

private list[Detection] detectionsExtraMethod(M3 client, BreakingChanges bc)
	= detections(client, bc, changedParamList())
	+ detections(client, bc, changedReturnType())
	;

private list[Detection] detections(M3 client, BreakingChanges bc, changedAccessModifier()) 
	= detections(client, bc.changedAccessModifier, changedAccessModifier());

private list[Detection] detections(M3 client, BreakingChanges bc, changedFinalModifier()) 
	= detections(client, bc.changedFinalModifier, changedFinalModifier());
	
private list[Detection] detections(M3 client, BreakingChanges bc, moved()) 
	= detections(client, bc.moved, moved());

private list[Detection] detections(M3 client, BreakingChanges bc, removed()) 
	= detections(client, bc.removed, removed());
	
private list[Detection] detections(M3 client, BreakingChanges bc, renamed()) 
	= detections(client, bc.renamed, renamed());

private list[Detection] detections(M3 client, BreakingChanges bc, changedParamList()) 
	= detections(client, bc.changedParamList, changedParamList());

private list[Detection] detections(M3 client, BreakingChanges bc, changedReturnType()) 
	= detections(client, bc.changedReturnType, changedReturnType());
	
private list[Detection] detections(M3 client, rel[loc, Mapping[&T, &T]] bcSet, BCType \type) {
	uses = rangeR(client.uses, domain(bcSet));
	return [detection(elem, used, mapping, \type) | <elem, used> <- uses, mapping <- bcSet[used]];
}
