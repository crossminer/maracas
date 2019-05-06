module org::maracas::delta::Detector

import IO;
import lang::java::m3::Core;
import org::maracas::delta::Delta;
import Relation;


//----------------------------------------------
// ADT
//----------------------------------------------

data Detection = detection (
	loc elem,
	loc used,
	Mapping[&T] mapping, 
	DeltaType typ
);

data DeltaType
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

set[Detection] detections(M3 client, Delta delta)
	= detectionsCore(client, delta) + detectionsExtra(client, delta);
	
private set[Detection] detectionsCore(M3 client, Delta delta)
	= detections(client, delta, changedAccessModifier())
	+ detections(client, delta, changedFinalModifier())
	+ detections(client, delta, changedStaticModifier())
	+ detections(client, delta, changedAbstractModifier())
	+ detections(client, delta, deprecated())
	+ detections(client, delta, renamed())
	+ detections(client, delta, moved())
	+ detections(client, delta, removed())
	;

private set[Detection] detectionsExtra(M3 client, Delta delta) {
	return switch (delta) {
		case \class(_): return detectionsExtraClass(client, delta);
		case \method(_): return detectionsExtraMethod(client, delta);
		case \field(_): return detectionsExtraField(client, delta);
		default: return [];
	}
}

private set[Detection] detectionsExtraClass(M3 client, Delta delta)
	= detections(client, delta, changedExtends())
	+ detections(client, delta, changedImplements())
	;
	
private set[Detection] detectionsExtraMethod(M3 client, Delta delta)
	= detections(client, delta, changedParamList())
	+ detections(client, delta, changedReturnType())
	;

private set[Detection] detectionsExtraField(M3 client, Delta delta)
	= detections(client, delta, changedType())
	;

private set[Detection] detections(M3 client, Delta delta, changedAccessModifier()) 
	= detections(client, delta.changedAccessModifier, changedAccessModifier());

private set[Detection] detections(M3 client, Delta delta, changedFinalModifier()) 
	= detections(client, delta.changedFinalModifier, changedFinalModifier());

private set[Detection] detections(M3 client, Delta delta, changedStaticModifier()) 
	= detections(client, delta.changedStaticModifier, changedStaticModifier());

private set[Detection] detections(M3 client, Delta delta, changedAbstractModifier()) 
	= detections(client, delta.changedAbstractModifier, changedAbstractModifier());

private set[Detection] detections(M3 client, Delta delta, deprecated()) 
	= detections(client, delta.deprecated, deprecated());

private set[Detection] detections(M3 client, Delta delta, renamed()) 
	= detections(client, delta.renamed, renamed());
	
private set[Detection] detections(M3 client, Delta delta, moved()) 
	= detections(client, delta.moved, moved());

private set[Detection] detections(M3 client, Delta delta, removed()) 
	= detections(client, delta.removed, removed());

private set[Detection] detections(M3 client, Delta delta, changedExtends()) 
	= detections(client, delta.changedExtends, changedExtends());
	
private set[Detection] detections(M3 client, Delta delta, changedImplements()) 
	= detections(client, delta.changedImplements, changedImplements());
	
private set[Detection] detections(M3 client, Delta delta, changedParamList()) 
	= detections(client, delta.changedParamList, changedParamList());

private set[Detection] detections(M3 client, Delta delta, changedReturnType()) 
	= detections(client, delta.changedReturnType, changedReturnType());

private set[Detection] detections(M3 client, Delta delta, changedType()) 
	= detections(client, delta.changedType, changedType());
		
private set[Detection] detections(M3 client, rel[loc, Mapping[&T]] deltaRel, DeltaType typ) {	
	set[loc] domain = domain(deltaRel);
	uses = rangeR(client.typeDependency, domain)
		+ rangeR(client.methodInvocation, domain)
		+ rangeR(client.fieldAccess, domain)
		+ rangeR(client.implements, domain)
		+ rangeR(client.extends, domain);
		
	return { detection(elem, used, mapping, typ) | <loc elem, loc used> <- uses, mapping <- deltaRel[used] };
}