module org::maracas::delta::Migration

import Relation;
import Set;
import IO;
import String;

import org::maracas::delta::Detector;
import org::maracas::m3::Core;
import lang::java::m3::Core;

data Migration(
	loc oldDecl = |unknown:///|,
	loc newDecl = |unknown:///|,
	loc oldUsed = |unknown:///|,
	loc newUsed = |unknown:///|,
	set[loc] oldUses = {},
	set[loc] newUses = {}
) = migration(loc oldClient, loc newClient, Detection d);

Migration buildMigration(Detection detect, loc newClient) {
	loc oldClient = detect.jar;
	loc oldDecl = detect.elem;
	loc newDecl = detect.elem; // 1-to-1 for now
	loc oldUsed = detect.used;
	loc newUsed = replacement(detect);
	M3 oldM3 = m3(oldClient);
	M3 newM3 = m3(newClient);
	
	Migration m = migration(oldClient, newClient, detect);
	
	if (oldDecl in domain(oldM3.declarations)) {
		m.oldDecl = oldDecl;
		m.oldUses = uses(oldM3, oldDecl);

		if (oldUsed in m.oldUses)
			m.oldUsed = oldUsed;
	}

	if (newDecl in domain(newM3.declarations)) {
		m.newDecl = newDecl;
		m.newUses = uses(newM3, newDecl);
		
		if (newUsed in m.newUses)
			m.newUsed = newUsed;
	}

	return m;
}

set[Migration] buildMigrations(set[Detection] detects, loc clientsPath) {
	set[Migration] result = {};

	int i = 0;
	for (Detection d <- detects) {
		i = i + 1;
		if (/<name: \S*>-[0-9]+/ := d.jar.file) {
			loc newClient = findJar(clientsPath, name);
			println("[<i>/<size(detects)>] Analyzing <newClient> [<d.typ>]");
			if (newClient != |unknown:///|)
				result += buildMigration(d, newClient);
		}
	}
	
	return result;
}

void checkMigrations(set[Migration] ms) {
	for (Migration m <- ms) {
		println("[<m.d.typ>] For <m.oldClient> -\> <m.newClient>");
	
		if (m.oldDecl == |unknown:///|)
			println("Couldn\'t find old declaration in old JAR");
		
		if (m.newDecl == |unknown:///|)
			println("Couldn\'t find new declaration in new JAR");
		
		if (m.oldUsed notin m.oldUses)
			println("oldUsed notin oldUses");
		
		if (m.newUsed notin m.newUses)
			println("newUsed notin newUses");
			
		if (m.oldUsed in m.newUses)
			println("oldUsed still in newUses");
	}
}

loc findJar(loc directory, str name) {
	for (str e <- listEntries(directory)) {
		loc jar = directory + e;
		
		if (contains(jar.file, name))
			return jar;
	}

	return |unknown:///|;
}

set[loc] uses(M3 m, loc decl)
	= m.typeDependency[decl]
	+ m.methodInvocation[decl]
	+ m.fieldAccess[decl]
	+ m.implements[decl]
	+ m.extends[decl]; 

loc replacement(detection(_, elem, _, _, accessModifiers())) = elem; // If it's now private, maps to nothing, if protected, depends on IoC
loc replacement(detection(_, elem, _, _, finalModifiers())) = elem; // Depends on IoC (?)
loc replacement(detection(_, elem, _, _, staticModifiers())) = elem; // same
loc replacement(detection(_, elem, _, _, abstractModifiers())) = elem; // Depends on IoC; clients might have their own new implementation; or, most likely, the API now has a new Class that implements the now-abstract method, or...
loc replacement(detection(_, elem, _, _, paramLists())) = elem; // NOPE, FIXME
loc replacement(detection(_, elem, _, _, types())) = elem;
loc replacement(detection(_, elem, _, _, extends())) = elem;
loc replacement(detection(_, elem, _, _, implements())) = elem;
loc replacement(detection(_, elem, _, _, deprecated())) = elem;
loc replacement(detection(_, elem, _, <old, new, _, _>, renamed())) = new;
loc replacement(detection(_, elem, _, <old, new, _, _>, moved())) = new;
