module org::maracas::m3::M3Diff

import lang::java::m3::Core;

data M3Diff(
	M3 removals = {},
	M3 additions = {}
	) 
	= m3Diff(M3 from, M3 to);

M3Diff createM3Diff(M3 from, M3 to) {
	M3Diff diff = m3Diff(from, to);
	diff.removals = m3Removals(from, to);
	diff.additions = m3Additions(from, to);
	return diff;
}

M3 m3Removals(M3 from, M3 to) 
	= diffJavaM3(from.id, [from, to]);
	 
M3 m3Additions(M3 from, M3 to) 
	= diffJavaM3(from.id, [to, from]);