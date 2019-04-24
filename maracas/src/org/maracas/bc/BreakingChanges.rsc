module org::maracas::bc::BreakingChanges

import lang::java::m3::AST;
import lang::java::m3::Core;


data BreakingChanges (
	rel[loc elem, Mapping[Modifier] mapping] changedAccessModifier = {},
	rel[loc elem, Mapping[Modifier] mapping] changedFinalModifier = {},
	rel[loc elem, Mapping[Modifier] mapping] changedStaticModifier = {},
	rel[loc elem, Mapping[Modifier] mapping] changedAbstractModifier = {},
	rel[loc elem, Mapping[loc] mapping] deprecated = {},
	rel[loc elem, Mapping[loc] mapping] moved = {},
	rel[loc elem, Mapping[loc] mapping] removed = {},
	rel[loc elem, Mapping[loc] mapping] renamed = {},
	map[str, str] options = ())
	= class (
		tuple[loc, loc] id)
	| method (
		tuple[loc, loc] id,
		rel[loc elem, Mapping[list[TypeSymbol]] mapping] changedParamList = {},
		rel[loc elem, Mapping[TypeSymbol] mapping] changedReturnType = {})
	| field(
		tuple[loc, loc] id,
		rel[loc elem, Mapping[TypeSymbol] mapping] changedType = {})
	;

alias Mapping[&T] 
	= tuple[
		&T from, 
		&T to,
		real conf,
		str method
	];
	