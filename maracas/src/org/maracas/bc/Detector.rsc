module org::maracas::bc::Detector

import IO;
import lang::java::m3::Core;
import org::maracas::bc::BreakingChanges;
import Relation;


//----------------------------------------------
// ADT
//----------------------------------------------

data Detection = detection (
	loc elem,
	loc used,
	Mapping[&T] mapping, 
	BCType typ
);

data BCType
	= changedAccessModifier()
	| changedFinalModifier()
	| changedStaticModifier()
	| changedAbstractModifier()
	| deprecated()
	| renamed()
	| moved()
	| removed()
	| changedParamList()
	| changedReturnType()
	| changedType()
	| changedExtends()
	| changedImplements()
	;
	

//----------------------------------------------
// Builder
//----------------------------------------------

set[Detection] detections(M3 client, BreakingChanges bc)
	= detectionsCore(client, bc) + detectionsExtra(client, bc);
	
private set[Detection] detectionsCore(M3 client, BreakingChanges bc)
	= detections(client, bc, changedAccessModifier())
	+ detections(client, bc, changedFinalModifier())
	+ detections(client, bc, changedStaticModifier())
	+ detections(client, bc, changedAbstractModifier())
	+ detections(client, bc, deprecated())
	+ detections(client, bc, renamed())
	+ detections(client, bc, moved())
	+ detections(client, bc, removed())
	;

private set[Detection] detectionsExtra(M3 client, BreakingChanges bc) {
	return switch (bc) {
		case \class(_): return detectionsExtraClass(client, bc);
		case \method(_): return detectionsExtraMethod(client, bc);
		case \field(_): return detectionsExtraField(client, bc);
		default: return [];
	}
}

private set[Detection] detectionsExtraClass(M3 client, BreakingChanges bc)
	= detections(client, bc, changedExtends())
	+ detections(client, bc, changedImplements())
	;
	
private set[Detection] detectionsExtraMethod(M3 client, BreakingChanges bc)
	= detections(client, bc, changedParamList())
	+ detections(client, bc, changedReturnType())
	;

private set[Detection] detectionsExtraField(M3 client, BreakingChanges bc)
	= detections(client, bc, changedType())
	;

private set[Detection] detections(M3 client, BreakingChanges bc, changedAccessModifier()) 
	= detections(client, bc.changedAccessModifier, changedAccessModifier());

private set[Detection] detections(M3 client, BreakingChanges bc, changedFinalModifier()) 
	= detections(client, bc.changedFinalModifier, changedFinalModifier());

private set[Detection] detections(M3 client, BreakingChanges bc, changedStaticModifier()) 
	= detections(client, bc.changedStaticModifier, changedStaticModifier());

private set[Detection] detections(M3 client, BreakingChanges bc, changedAbstractModifier()) 
	= detections(client, bc.changedAbstractModifier, changedAbstractModifier());

private set[Detection] detections(M3 client, BreakingChanges bc, deprecated()) 
	= detections(client, bc.deprecated, deprecated());

private set[Detection] detections(M3 client, BreakingChanges bc, renamed()) 
	= detections(client, bc.renamed, renamed());
	
private set[Detection] detections(M3 client, BreakingChanges bc, moved()) 
	= detections(client, bc.moved, moved());

private set[Detection] detections(M3 client, BreakingChanges bc, removed()) 
	= detections(client, bc.removed, removed());

private set[Detection] detections(M3 client, BreakingChanges bc, changedExtends()) 
	= detections(client, bc.changedExtends, changedExtends());
	
private set[Detection] detections(M3 client, BreakingChanges bc, changedImplements()) 
	= detections(client, bc.changedImplements, changedImplements());
	
private set[Detection] detections(M3 client, BreakingChanges bc, changedParamList()) 
	= detections(client, bc.changedParamList, changedParamList());

private set[Detection] detections(M3 client, BreakingChanges bc, changedReturnType()) 
	= detections(client, bc.changedReturnType, changedReturnType());

private set[Detection] detections(M3 client, BreakingChanges bc, changedType()) 
	= detections(client, bc.changedType, changedType());
		
private set[Detection] detections(M3 client, rel[loc, Mapping[&T]] bcRel, BCType typ) {	
	set[loc] domain = domain(bcRel);
	uses = rangeR(client.typeDependency, domain)
		+ rangeR(client.methodInvocation, domain)
		+ rangeR(client.fieldAccess, domain)
		+ rangeR(client.implements, domain)
		+ rangeR(client.extends, domain);
		
	return { detection(elem, used, mapping, typ) | <loc elem, loc used> <- uses, mapping <- bcRel[used] };
}