module org::maracas::m3::SourceToJar

import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::m3::Core;

import String;


loc toJarInnerClass(loc logical) {
	logical.path = visit(logical.path) {
	case /<outer:\w+>\/<inner:\w+>$/ => "<outer>$<inner>"
	}
	return logical;
}