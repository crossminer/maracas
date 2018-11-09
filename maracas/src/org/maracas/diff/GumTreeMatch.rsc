@doc{ 
	Taken from:
	Jean-Rémy Falleri, Floréal Morandat, Xavier Blanc, Matias Martinez, and Martin Monperrus.
	2014. Fine-grained and accurate source code differencing. 
	In 29th International Conference on Automated Software Engineering. ACM, New York, 313-324. 
	
	Some modifications have been applied.
} 
module org::maracas::diff::GumTreeMatch

import IO;
import lang::java::m3::AST;
import Node;
import org::maracas::diff::Tree;


list[value] topDownMatch(Declaration ast1, Declaration ast2, int minHeight) {
	priority1 = [];
	priority2 = [];
	candidates = [];
	mappings = [];
	
	priority1 += ast1;
	priority2 += ast2;
	
	return mappings;
}

