module org::maracas::\test::bc::TestApiOldApiNew

import IO;
import Set;
import lang::java::m3::AST;
import lang::java::m3::TypeSymbol;
import org::maracas::bc::BreakingChanges;
import org::maracas::bc::BreakingChangesBuilder;
import org::maracas::Maracas;
import org::maracas::config::Options;

// TODO: what about constructors?

// Assuming they have been imported and built beforehand
loc v1 = |project://api-old/target/old-0.0.1-SNAPSHOT.jar|;
loc v2 = |project://api-new/target/new-0.0.1-SNAPSHOT.jar|;

BreakingChanges cbc = classBreakingChanges(v1, v2);
BreakingChanges mbc = methodBreakingChanges(v1, v2);
BreakingChanges fbc = fieldBreakingChanges(v1, v2);

// final api.FinalModifierRemoved -> api.FinalModifierRemoved
test bool classFinalModifierRemoved() =
	<|java+class:///api/FinalModifierRemoved|, <\final(), \default(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedFinalModifier;

// api.FinalModifierAdded -> final api.FinalModifierAdded
test bool classFinalModifierAdded() =
	<|java+class:///api/FinalModifierAdded|, <\default(), \final(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedFinalModifier;

test bool classNoMoreFinalModifiers() =
	size(cbc.changedFinalModifier) == 2;

// abstract api.AbstractModifierRemoved -> api.AbstractModifierRemoved
test bool classAbstractModifierRemoved() =
	<|java+class:///api/AbstractModifierRemoved|, <\abstract(), \default(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedAbstractModifier
	&& size(cbc.changedAbstractModifier) == 2;

// api.AbstractModifierAdded -> abstract api.AbstractModifierAdded
test bool classAbstractModifierAdded() =
	<|java+class:///api/AbstractModifierAdded|, <\default(), \abstract(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedAbstractModifier
	&& size(cbc.changedAbstractModifier) == 2;

test bool classNoMoreAbstractModifiers() =
	size(cbc.changedAbstractModifier) == 2;

// public api.AccessModifierRemoved -> api.AccessModifierRemoved
test bool classAccessModifierRemoved() =
	<|java+class:///api/AccessModifierRemoved|, <\public(), \defaultAccess(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedAccessModifier;

// api.AccessModifierAdded -> public api.AccessModifierAdded
test bool classAccessModifierRemoved() =
	<|java+class:///api/AccessModifierAdded|, <\defaultAccess(), \public(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedAccessModifier;

// interface api.InterfaceAccessModifierAdded -> public interface api.InterfaceAccessModifierAdded
test bool interfaceAccessModifierAdded() =
	<|java+interface:///api/InterfaceAccessModifierAdded|, <\defaultAccess(), \public(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedAccessModifier;

// public interface api.InterfaceAccessModifierRemoved-> interface api.InterfaceAccessModifierRemoved
test bool interfaceAccessModifierRemoved() =
	<|java+interface:///api/InterfaceAccessModifierRemoved|, <\public(), \defaultAccess(), 1.0, MATCH_SIGNATURE>>
	in cbc.changedAccessModifier;

test bool classNoMoreAccessModifiers() =
	size(cbc.changedAccessModifier) == 4;

// api.DeprecatedAdded -> @Deprecated api.DeprecatedAdded
test bool classDeprecated() =
	<|java+class:///api/DeprecatedAdded|, <|java+class:///api/DeprecatedAdded|, |java+class:///api/DeprecatedAdded|, 1.0, MATCH_SIGNATURE>>
	in cbc.deprecated;

test bool classNoMoreDeprecated() =
	size(cbc.deprecated) == 1;

// api.AccessModifierAdded.AccessModifierAdded() -> public api.AccessModifierAdded.AccessModifierAdded()
test bool constructorAccessModifierAdded() =
	<|java+constructor:///api/AccessModifierAdded/AccessModifierAdded()|, <\defaultAccess(), \public(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// api.AccessModifierRemoved.AccessModifierRemoved() -> public api.AccessModifierRemoved.AccessModifierRemoved()
test bool constructorAccessModifierRemoved() =
	<|java+constructor:///api/AccessModifierRemoved/AccessModifierRemoved()|, <\public(), \defaultAccess(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// private api.A.mAccessModifierPrivateToPublic() -> public api.A.mAccessModifierPrivateToPublic()
test bool methodAccessModifierPrivateToPublic() =
	<|java+method:///api/A/mAccessModifierPrivateToPublic()|, <\private(), \public(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// public api.A.mAccessModifierPublicToPrivate() -> private api.A.mAccessModifierPublicToPrivate()
test bool methodAccessModifierPublicToPrivate() =
	<|java+method:///api/A/mAccessModifierPublicToPrivate()|, <\public(), \private(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// api.A.mAccessModifierDefaultToPrivate() -> private api.A.mAccessModifierDefaultToPrivate()
test bool methodAccessModifierDefaultToPrivate() =
	<|java+method:///api/A/mAccessModifierDefaultToPrivate()|, <\defaultAccess(), \private(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// api.A.mAccessModifierDefaultToPublic() -> public api.A.mAccessModifierDefaultToPublic()
test bool methodAccessModifierDefaultToPublic() =
	<|java+method:///api/A/mAccessModifierDefaultToPublic()|, <\defaultAccess(), \public(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// private api.A.mAccessModifierPrivateToDefault() -> api.A.mAccessModifierPrivateToDefault()
test bool methodAccessModifierPrivateToDefault() =
	<|java+method:///api/A/mAccessModifierPrivateToDefault()|, <\private(), \defaultAccess(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

// public api.A.mAccessModifierPublicToDefault() -> api.A.mAccessModifierPublicToDefault()
test bool methodAccessModifierPublicToDefault() =
	<|java+method:///api/A/mAccessModifierPublicToDefault()|, <\public(), \defaultAccess(), 1.0, MATCH_SIGNATURE>>
	in mbc.changedAccessModifier;

test bool methodNoMoreAccessModifiers() =
	size(mbc.changedAccessModifier) == 8;

// api.A.mDeprecated -> @Deprecated api.A.mDeprecated
test bool methodDeprecated() =
	<|java+method:///api/A/mDeprecated()|, <|java+method:///api/A/mDeprecated()|, |java+method:///api/A/mDeprecated()|, 1.0, MATCH_SIGNATURE>>
	in mbc.deprecated;

test bool methodNoMoreDeprecated() =
	size(mbc.deprecated) == 1;

// public api.A.fPublicToPrivate -> private api.A.fPublicToPrivate
test bool fieldPublicToPrivate() =
	<|java+field:///api/A/fPublicToPrivate|, <\public(), \private(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedAccessModifier;

// api.A.fDefaultToPrivate -> private api.A.fDefaultToPrivate
test bool fieldDefaultToPrivate() =
	<|java+field:///api/A/fDefaultToPrivate|, <\defaultAccess(), \private(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedAccessModifier;

// public api.A.fPublicToDefault -> api.A.fPublicToDefault
test bool fieldPublicToDefault() =
	<|java+field:///api/A/fPublicToDefault|, <\public(), \defaultAccess(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedAccessModifier;

test bool fieldNoMoreAccessModifiers() =
	size(fbc.changedAccessModifier) == 3;

// String api.A.fFinalModifierAdded -> final String api.A.fFinalModifierAdded
test bool fieldFinalModifierAdded() =
	<|java+field:///api/A/fFinalModifierAdded|, <\default(), \final(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedFinalModifier;

// final String api.A.fFinalModifierRemoved -> String api.A.fFinalModifierRemoved
test bool fieldFinalModifierRemoved() =
	<|java+field:///api/A/fFinalModifierRemoved|, <\final(), \default(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedFinalModifier;

test bool fieldNoMoreFinalModifiers() =
	size(fbc.changedFinalModifier) == 2;

// float api.A.fStaticModifierAdded -> static float api.A.fStaticModifierAdded
test bool fieldStaticModifierAdded() =
	<|java+field:///api/A/fStaticModifierAdded|, <\default(), \static(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedStaticModifier;

// static float api.A.fStaticModifierRemoved -> float api.A.fStaticModifierRemoved
test bool fieldStaticModifierRemoved() =
	<|java+field:///api/A/fStaticModifierRemoved|, <\static(), \default(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedStaticModifier;

test bool fieldNoMoreStaticModifiers() =
	size(fbc.changedStaticModifier) == 2;

// int api.A.fDeprecated -> @Deprecated int api.A.fDeprecated
test bool fieldDeprecated() =
	<|java+field:///api/A/fDeprecated|, <|java+field:///api/A/fDeprecated|, |java+field:///api/A/fDeprecated|, 1.0, MATCH_SIGNATURE>>
	in fbc.deprecated;

test bool fieldNoMoreDeprecated() =
	size(fbc.deprecated) == 1;

// String api.A.fStringToInt -> int api.A.fStringToInt
test bool fieldStringToInt() =
	<|java+field:///api/A/fStringToInt|, <TypeSymbol::\class(|java+class:///java/lang/String|, []), TypeSymbol::\int(), 1.0, MATCH_SIGNATURE>>
	in fbc.changedType;

// String api.A.fStringToList -> List<String> api.A.fStringToList
// FIXME: Fix when we fix the bug java+class:// -> java+interface:/
test bool fieldStringToList() =
	<|java+field:///api/A/fStringToList|, <TypeSymbol::\class(|java+class:///java/lang/String|, []), TypeSymbol::\class(|java+class:///java/util/List|, []), 1.0, MATCH_SIGNATURE>>
	in fbc.changedType;

// RateLimiter api.A.fLimiterToGuard -> Guard api.A.fLimiterToGuard
test bool fieldExternalTypeToExternalType() =
	<|java+field:///api/A/fLimiterToGuard|, <TypeSymbol::\class(|java+class:///com/google/common/util/concurrent/RateLimiter|, []), TypeSymbol::\class(|java+class:///com/google/common/util/concurrent/Monitor$Guard|, []), 1.0, MATCH_SIGNATURE>>
	in fbc.changedType;

test bool fieldNoMoreChangedType() =
	size(fbc.changedType) == 3;
