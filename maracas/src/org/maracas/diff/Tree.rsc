module org::maracas::diff::Tree

import Node;


int computeMaxHeight(&T <: node n) {
	maxHeight = 0;
	children = getChildren(n);
	childrenList = [];
	
	for(c <- children) {
		if(&R <: node e := c) {
			maxHeight = updateMaxHeight(maxHeight, e);
			continue;
		}
		if (list[value] e := c) {
			childrenList += e;
		}
	}
	
	for(c <- childrenList) {
		if(&R <: node e := c) {
			maxHeight = updateMaxHeight(maxHeight, e);
		}
	}
	
	return maxHeight + 1;
}

int updateMaxHeight(int maxHeight, node n) {
	nodeHeight = computeMaxHeight(n);
	return (nodeHeight > maxHeight) ? nodeHeight : maxHeight;
}