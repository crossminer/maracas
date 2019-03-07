module org::maracas::m3::M3Diff

import lang::java::m3::Core;

data M3Diff(
	rel[loc from, loc to] removals = {},
	rel[loc from, loc to] additions = {},
	rel[loc from, loc to] modifications = {}
	) 
	= m3Diff(tuple[M3 from, M3 to] m3s);

M3Diff createM3Diff(M3 from, M3 to) {
	M3Diff diff = m3Diff(from,to);
	diff.removals = m3Removals(from, to);
	diff.additions = m3Additions(from, to);
	diff.modifications = m3Modifications(from, to);
	return diff;
}

@memo 
M3 m3Removals(M3 from, M3 to) 
	= diffJavaM3(from.id, [from, to]);
	
@memo 
M3 m3Additions(M3 from, M3 to) 
	= diffJavaM3(from.id, [to, from]);

@memo
M3 m3Modifications(M3 from, M3 to) 
	= m3Removals(from, to) & m3Additions(from, to);