module org::maracas::\test::diff::TreeTest

import org::maracas::diff::Tree;


@doc {
	Taken from Rascal demo::common::CountConstructors
}
data ColoredTree = leaf(int N)      
                 | red(ColoredTree left, ColoredTree right) 
                 | black(ColoredTree left, ColoredTree right);

public ColoredTree ct1 = black(black(leaf(1), red(leaf(2), red(leaf(3), leaf(4)))), red(leaf(5), leaf(6)));
public ColoredTree ct2 = leaf(1);
public ColoredTree ct3 = black(leaf(2), leaf(1));
public ColoredTree ct4 = red(black(red(leaf(1), leaf(2)), leaf(3)), black(red(leaf(4), leaf(5)), leaf(6)));
public ColoredTree ct5 = black(leaf(2), leaf(1));


// height
test bool height1() = height(ct1) == 5;
test bool height2() = height(ct2) == 1;
test bool height3() = height(ct3) == 2;
test bool height4() = height(ct4) == 4;


// canonicalStr
test bool canonicalStr1() = canonicalStr(ct1)
	== "black$#blackred$#leafred$leafleaf$#1$leafred$5$6$#2$leafleaf$#3$4$#";
	
test bool canonicalStr2() = canonicalStr(ct2)
	== "leaf$#1$#";
	
test bool canonicalStr3() = canonicalStr(ct3)
	== "black$#leafleaf$#2$1$#";
	
test bool canonicalStr4() = canonicalStr(ct4)
	== "red$#blackblack$#redleaf$redleaf$#leafleaf$3$leafleaf$6$#1$2$4$5$#";
	

// isomorphic
test bool isomorphic1() = isomorphic(ct3, ct5);
test bool isomorphic2() = isomorphic(ct5, ct3);
test bool isomorphic3() = isomorphic(ct3, ct3);
test bool isomorphic4() = !isomorphic(ct2, ct1);
test bool isomorphic5() = !isomorphic(ct1, ct4);