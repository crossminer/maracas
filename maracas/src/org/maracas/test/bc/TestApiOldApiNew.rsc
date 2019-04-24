module org::maracas::\test::bc::TestApiOldApiNew

import IO;
import Set;
import lang::java::m3::AST;
import org::maracas::bc::BreakingChanges;
import org::maracas::Maracas;

// TODO: what about constructors?

// Assuming they have been imported and built beforehand
loc v1 = |project://api-old/target/old-0.0.1-SNAPSHOT.jar|;
loc v2 = |project://api-new/target/new-0.0.1-SNAPSHOT.jar|;

BreakingChanges cbc = classBreakingChanges(v1, v2);
BreakingChanges mbc = methodBreakingChanges(v1, v2);
BreakingChanges fbc = fieldBreakingChanges(v1, v2);

// final api.FinalModifierRemoved -> api.FinalModifierRemoved
test bool classFinalModifierRemoved()
	= <|java+class:///api/FinalModifierRemoved|, <\final(), \default(), 1.0, "signature">>
	in cbc.changedFinalModifier;

// api.FinalModifierAdded -> final api.FinalModifierAdded
test bool classFinalModifierAdded()
	= <|java+class:///api/FinalModifierAdded|, <\default(), \final(), 1.0, "signature">>
	in cbc.changedFinalModifier;

// abstract api.AbstractModifierRemoved -> api.AbstractModifierRemoved
test bool classAbstractModifierRemoved()
	= <|java+class:///api/AbstractModifierRemoved|, <\abstract(), \default(), 1.0, "signature">>
	in cbc.changedAbstractModifier;

// api.AbstractModifierAdded -> abstract api.AbstractModifierAdded
test bool classAbstractModifierAdded()
	= <|java+class:///api/AbstractModifierAdded|, <\default(), \abstract(), 1.0, "signature">>
	in cbc.changedAbstractModifier;

// api.DeprecatedAdded -> @Deprecated api.DeprecatedAdded
test bool classDeprecated()
	= <|java+class:///api/DeprecatedAdded|, <|java+class:///api/DeprecatedAdded|, |java+class:///api/DeprecatedAdded|, 1.0, "signature">>
	in cbc.deprecated
	&& size(cbc.deprecated) == 1;

// api.A.mDeprecated -> @Deprecated api.A.mDeprecated
test bool methodDeprecated()
	= <|java+method:///api/A/mDeprecated()|, <|java+method:///api/A/mDeprecated()|, |java+method:///api/A/mDeprecated()|, 1.0, "signature">>
	in mbc.deprecated
	&& size(mbc.deprecated) == 1;
