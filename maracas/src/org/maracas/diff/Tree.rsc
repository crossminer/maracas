module org::maracas::diff::Tree

import Node;


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
	Checks if two trees are isomorphic.
	TODO
}
boolean isomorphic(&T <: node t1, &S <: node t2) {
	return true;
}