module org::maracas::\test::diff::GumTreeMatchTest

import lang::java::m3::AST;
import lang::java::m3::Core;
import List;
import org::maracas::diff::GumTreeMatch;


Declaration ast1 = createAstFromFile(|project://maracas/src/org/maracas/test/data/AST1.java|, true);
Declaration ast2 = createAstFromFile(|project://maracas/src/org/maracas/test/data/AST2.java|, true);
Declaration ast3 = createAstFromFile(|project://maracas/src/org/maracas/test/data/AST3.java|, true);
Declaration ast4 = createAstFromFile(|project://maracas/src/org/maracas/test/data/AST4.java|, true);

test bool topDownMatchAST1() = size(topDownMatch(ast1, ast4, 2)) == 1;
test bool topDownMatchAST2() = size(topDownMatch(ast4, ast1, 2)) == 1;
test bool topDownMatchAST3() = size(topDownMatch(ast2, ast2, 2)) == 1;
test bool topDownMatchAST4() = size(topDownMatch(ast2, ast3, 2)) == 0;
test bool topDownMatchAST5() = size(topDownMatch(ast3, ast2, 2)) == 0;