module org::maracas::diff::Matcher

import lang::java::m3::Core;


data Matcher = matcher(
	set[Match] (M3 added, M3 removed) match);

alias Match 
	= tuple[
		int confidence, 
		tuple[loc from, loc to] match
	];
	
	//matcher(
	//rel[int confidence, Match match] hola(){
	//kfjhsdfdhkdfs
	//}
	//);
	
	
	//matcher(hola);
	//rel[int confidence, Match match] hola(){
	//kfjhsdfdhkdfs