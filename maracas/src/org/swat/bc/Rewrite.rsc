@doc{
	This module uses term rewriting to support program transformation.
	Only breaking and solvable changes are considered within it.
}
module org::swat::m3::Rewrite

import org::swat::bc::BreakingChanges;
import org::swat::lang::mj::Syntax;
import Set;


Program rewrite(Program p, BC m) {
	return visit (p) {
		case Statement s => rewrite(s, m)
	}
}

Statement rewrite((Statement)`<Id invoker>.<Id meth> ( <{Id ","}* args> );`, BC m) {
	renamings = {<(Id)`add`, (Id)`sum`>};
	if(renamings[meth] != {}) {
		Id methModf = getFirstFrom(renamings[meth]);
		return (Statement)`<Id invoker>.<Id methModf> ( <{Id ","}* args> );`;
	} 
	return s;
}

