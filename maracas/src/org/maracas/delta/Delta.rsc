module org::maracas::delta::Delta

import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::m3::Core;


data Delta (
	rel[loc elem, Mapping[Modifier] mapping] accessModifiers = {},
	rel[loc elem, Mapping[Modifier] mapping] finalModifiers = {},
	rel[loc elem, Mapping[Modifier] mapping] staticModifiers = {},
	rel[loc elem, Mapping[Modifier] mapping] abstractModifiers = {},
	rel[loc elem, Mapping[list[TypeSymbol]] mapping] paramLists = {},
	rel[loc elem, Mapping[TypeSymbol] mapping] types = {},
	rel[loc elem, Mapping[loc] mapping] extends = {},
	rel[loc elem, Mapping[set[loc]] mapping] implements = {},
	rel[loc elem, Mapping[loc] mapping] deprecated = {},
	rel[loc elem, Mapping[loc] mapping] renamed = {},
	rel[loc elem, Mapping[loc] mapping] moved = {},
	rel[loc elem, Mapping[loc] mapping] removed = {},
	map[str, str] options = ())
	= delta(tuple[loc from, loc to] id);

alias Mapping[&T] 
	= tuple[
		&T from, 
		&T to,
		real conf,
		str method
	];


Delta getClassDelta(Delta delta)
	= getFilteredDelta(delta, isType);	
	
Delta getMethodDelta(Delta delta)
	= getFilteredDelta(delta, isMethod);	
	
Delta getFieldDelta(Delta delta)
	= getFilteredDelta(delta, isField);	
	
private Delta getFilteredDelta(Delta delta, bool (loc) fun) {
	delta.accessModifiers 	= { m | m <- delta.accessModifiers, fun(m.elem) };
	delta.finalModifiers 	= { m | m <- delta.finalModifiers, fun(m.elem) };
	delta.staticModifiers 	= { m | m <- delta.staticModifiers, fun(m.elem) };
	delta.abstractModifiers = { m | m <- delta.abstractModifiers, fun(m.elem) };
	delta.paramLists 		= { m | m <- delta.paramLists, fun(m.elem) };
	delta.types 			= { m | m <- delta.types, fun(m.elem) };
	delta.extends 			= { m | m <- delta.extends, fun(m.elem) };
	delta.implements 		= { m | m <- delta.implements, fun(m.elem) };
	delta.deprecated 		= { m | m <- delta.deprecated, fun(m.elem) };
	delta.renamed 			= { m | m <- delta.renamed, fun(m.elem) };
	delta.moved 			= { m | m <- delta.moved, fun(m.elem) };
	delta.removed 			= { m | m <- delta.removed, fun(m.elem) };
	
	return delta;
}