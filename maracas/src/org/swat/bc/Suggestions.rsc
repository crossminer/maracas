module org::swat::bc::Suggestions

import IO;
import lang::java::m3::Core;
import org::swat::bc::BreakingChanges;
import Relation;


//----------------------------------------------
// ADT
//----------------------------------------------

data Suggestion = suggestion (
	loc elem,
	loc used, 
	Mapping[&T,&U] mapping, 
	BCType typ
);

data BCType
	= changedAccessModifier()
	| addedFinalModifier()
	| moved()
	| removed()
	| renamed()
	| changedParamList()
	| changedReturnType()
	;
	

//----------------------------------------------
// Builder
//----------------------------------------------

list[Suggestion] suggestions(M3 client, BreakingChanges bc)
	= suggestionsCore(client, bc) + suggestionsExtra(client, bc);
	
private list[Suggestion] suggestionsCore(M3 client, BreakingChanges bc)
	= suggestions(client, bc, changedAccessModifier())
	+ suggestions(client, bc, addedFinalModifier())
	+ suggestions(client, bc, moved())
	+ suggestions(client, bc, removed())
	+ suggestions(client, bc, renamed())
	;

private list[Suggestion] suggestionsExtra(M3 client, BreakingChanges bc) {
	return switch (bc) {
		case \method(_): return suggestionsExtraMethod(client, bc);
	}
}

private list[Suggestion] suggestionsExtraMethod(M3 client, BreakingChanges bc)
	= suggestions(client, bc, changedParamList())
	+ suggestions(client, bc, changedReturnType())
	;

private list[Suggestion] suggestions(M3 client, BreakingChanges bc, changedAccessModifier()) 
	= suggestions(client, bc.changedAccessModifier, changedAccessModifier());

private list[Suggestion] suggestions(M3 client, BreakingChanges bc, addedFinalModifier()) 
	= suggestions(client, bc.addedFinalModifier, addedFinalModifier());
	
private list[Suggestion] suggestions(M3 client, BreakingChanges bc, moved()) 
	= suggestions(client, bc.moved, moved());

private list[Suggestion] suggestions(M3 client, BreakingChanges bc, removed()) 
	= suggestions(client, bc.removed, removed());
	
private list[Suggestion] suggestions(M3 client, BreakingChanges bc, renamed()) 
	= suggestions(client, bc.renamed, renamed());

private list[Suggestion] suggestions(M3 client, BreakingChanges bc, changedParamList()) 
	= suggestions(client, bc.changedParamList, changedParamList());

private list[Suggestion] suggestions(M3 client, BreakingChanges bc, changedReturnType()) 
	= suggestions(client, bc.changedReturnType, changedReturnType());
	
private list[Suggestion] suggestions(M3 client, rel[loc, Mapping[&T, &T]] bcSet, BCType \type) {
	uses = rangeR(client.uses, domain(bcSet));
	return [suggestion(elem, used, mapping, \type) | <elem, used> <- uses, mapping <- bcSet[used]];
}
