module org::maracas::bc::BreakingChanges

import lang::java::m3::AST;
import lang::java::m3::Core;


data BreakingChanges (
	rel[loc elem, Mapping[Modifier, Modifier] mapping] changedAccessModifier = {},
	rel[loc elem, Mapping[Modifier, Modifier] mapping] changedFinalModifier = {},
	rel[loc elem, Mapping[Modifier, Modifier] mapping] changedStaticModifier = {},
	rel[loc elem, Mapping[loc, loc] mapping] deprecated = {},
	rel[loc elem, Mapping[loc, loc] mapping] moved = {},
	rel[loc elem, Mapping[loc, loc] mapping] removed = {},
	rel[loc elem, Mapping[loc, loc] mapping] renamed = {},
	map[str, str] options = ())
	= class (
		Mapping[loc, loc] id)
	| method (
		Mapping[loc, loc] id,
		rel[loc elem, Mapping[list[TypeSymbol], list[TypeSymbol]] mapping] changedParamList = {},
		rel[loc elem, Mapping[TypeSymbol, TypeSymbol] mapping] changedReturnType = {})
	| field(
		Mapping[loc, loc] id
		rel[loc elem, Mapping[TypeSymbol, TypeSymbol] mapping] changedType = {})
	;

alias Mapping[&T, &T] = tuple[&T from, &T to];
	