module org::swat::bc::vis::Visualizer

import IO;
import vis::Figure;
import vis::Render;

void renderBCList(str title, str msg, rel[str,str] mapping) {
	t = text("Breaking Change: <title>", fontSize(20), fontColor("blue"));
	m = text("<msg>", fontSize(12), fontColor("black"));

	rows = [];
	for(<p, n> <- mapping) {
		rows += [[ 
			text("<p>", fontSize(20), fontColor("red")),
			text("<n>", fontSize(20), fontColor("green"))
		]];
	}
	
	bcs = grid(rows);
	fig = vcat([t, m, bcs]);
	render("Breaking Changes", fig);
}