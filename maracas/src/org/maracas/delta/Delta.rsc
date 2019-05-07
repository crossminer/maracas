module org::maracas::delta::Delta

import lang::java::m3::AST;
import lang::java::m3::Core;


data Delta (
	rel[loc elem, Mapping[Modifier] mapping] changedAccessModifier = {},
	rel[loc elem, Mapping[Modifier] mapping] changedFinalModifier = {},
	rel[loc elem, Mapping[Modifier] mapping] changedStaticModifier = {},
	rel[loc elem, Mapping[Modifier] mapping] changedAbstractModifier = {},
	rel[loc elem, Mapping[loc] mapping] deprecated = {},
	rel[loc elem, Mapping[loc] mapping] renamed = {},
	rel[loc elem, Mapping[loc] mapping] moved = {},
	rel[loc elem, Mapping[loc] mapping] removed = {},
	rel[loc elem, Mapping[loc] mapping] changedExtends = {},
	rel[loc elem, Mapping[set[loc]] mapping] changedImplements = {},
	rel[loc elem, Mapping[list[TypeSymbol]] mapping] changedParamList = {},
	rel[loc elem, Mapping[TypeSymbol] mapping] changedType = {},
	map[str, str] options = ())
	= delta(tuple[loc from, loc to] id);

alias Mapping[&T] 
	= tuple[
		&T from, 
		&T to,
		real conf,
		str method
	];
	