module org::maracas::diff::Tree

import IO;
import List;
import Node;
import Type;


int height(&T <: node n) {
	maxHeight = 0;
	children = getChildren(n);
	childrenList = [];
	
	for(c <- children) {
		if(&R <: node e := c) {
			maxHeight = updateHeight(maxHeight, e);
			continue;
		}
		if (list[value] e := c) {
			childrenList += e;
		}
	}
	
	for(c <- childrenList) {
		if(&R <: node e := c) {
			maxHeight = updateHeight(maxHeight, e);
		}
	}
	
	return maxHeight + 1;
}

private int updateHeight(int maxHeight, node n) {
	nodeHeight = height(n);
	return (nodeHeight > maxHeight) ? nodeHeight : maxHeight;
}

set[node] descendants(&T <: node n) {
	children = getChildren(n);
	return {*(c + descendants(c)) | c <- children};
}

@doc {
	Returns the canonical string representation of a tree.
	It uses a breadth-first traversal. We also introduce
	the following characters:
		$: distinguishes children from different parents
		#: distinguishes different levels
}
str canonicalStr(&T <: node n) = canonicalStrBFT([[n]], "");

private str canonicalStrBFT(list[list[value]] nodeLists, str canon) {
	if(isEmpty(nodeLists)) {
		return canon;
	}
	
	list[list[value]]levelNodes = [];

	for(nodes <- nodeLists) {
		for(n <- nodes) {
			switch(n) {
				case &T <: node nod : {
					canon += label(nod);
					levelNodes += [getChildren(nod)];
				}
				case list[value] l : {
					// We use default Rascal sorting w.r.t element types 
					levelNodes += [sort(l)];
				}
				default :
					canon += "<n>";
			}			
		}
		canon += (!isEmpty(nodes)) ? "$" : "";
	}
	canon += (!isEmpty(nodeLists)) ? "#" : "";
	
	return "<canonicalStrBFT(levelNodes, canon)>"; 
}

@doc {
	For types Declaration, Statement, and Expression the 
	function generates a label in the form of: 
		"<nodeName>_<nodeSrc>"
	For a Type type:
		"<nodeName>_<typeName>"
	Otherwise:
		"<nodeName>"
}
private str label(&T <: node n) {
	params = getKeywordParameters(n);
	return ("name" in params) ? "<getName(n)>_<n.name>"
			: "<getName(n)>";
}

@doc {
	Taken from:
	Partha Biswas and Girish Venkataramani. 2008. Comprehensive isomorphic subtree enumeration. 
	In International Conference on Compilers, Architectures and Synthesis for Embedded Systems. 
	ACM, New York, 177-186.
	
	Two trees T1 = (V1,E1) and T2 = (V2,E2) are isomorphic 
	if there is a relation f : V1 -> V2 where:
	1) f is bijective (1-to-1 correspndence between nodes)
	2) f preserves the edge relations (between nodes)
	3) f preserves types (of nodes)
	4) For every ordered node, the ordering relation is preserved
	TODO
}
bool isomorphic(&T <: node t1, &S <: node t2) {
	return canonicalStr(t1) == canonicalStr(t2);
}