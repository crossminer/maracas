module org::swat::m3::Rewrite

import org::swat::lang::mj::Syntax;
import Set;

Program rewrite(Program p) {
	return visit (p) {
		case Statement s => rewrite(s)
	}
}

Statement rewrite(Statement s) {
	renamings = {<(Id)`add`, (Id)`sum`>};
	switch(s) {
		case (Statement)`<Id invoker>.<Id meth> ( <{Id ","}* args> );` : {
			if(renamings[meth] != {}) {
			 	Id methModf = getFirstFrom(renamings[meth]);
			 	return (Statement)`<Id invoker>.<Id methModf> ( <{Id ","}* args> );`;
			 } 
		}
		default: return s;
	}
	return s;
}

