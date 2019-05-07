module org::maracas::delta::Delta

import lang::java::m3::AST;
import lang::java::m3::Core;
import org::maracas::m3::Core;


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


Delta getClassDelta(Delta delta)
	= getFilteredDelta(delta, isType);	
	
Delta getMethodDelta(Delta delta)
	= getFilteredDelta(delta, isMethod);	
	
Delta getFieldDelta(Delta delta)
	= getFilteredDelta(delta, isField);	
	
private Delta getFilteredDelta(Delta delta, bool (loc) fun) {
	delta.changedAccessModifier 	= { m | m <- delta.changedAccessModifier, fun(m.elem) };
	delta.changedFinalModifier 		= { m | m <- delta.changedFinalModifier, fun(m.elem) };
	delta.changedStaticModifier 	= { m | m <- delta.changedStaticModifier, fun(m.elem) };
	delta.changedAbstractModifier 	= { m | m <- delta.changedAbstractModifier, fun(m.elem) };
	delta.deprecated 				= { m | m <- delta.deprecated, fun(m.elem) };
	delta.renamed 					= { m | m <- delta.renamed, fun(m.elem) };
	delta.moved 					= { m | m <- delta.moved, fun(m.elem) };
	delta.removed 					= { m | m <- delta.removed, fun(m.elem) };
	delta.changedExtends 			= { m | m <- delta.changedExtends, fun(m.elem) };
	delta.changedImplements 		= { m | m <- delta.changedImplements, fun(m.elem) };
	delta.changedParamList 			= { m | m <- delta.changedParamList, fun(m.elem) };
	delta.changedType 				= { m | m <- delta.changedType, fun(m.elem) };
	
	return delta;
}