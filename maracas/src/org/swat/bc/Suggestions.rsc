module org::swat::bc::Suggestions

import IO;
import lang::java::m3::Core;
import org::swat::bc::BreakingChanges;



/*
 * Changes in access modifiers
 */
void refactoringSuggestions(M3 m, BreakingChange bc) {
	println(m.methodInvocation o bcs.methodBCs.genericBCs.removed);
}