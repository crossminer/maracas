module org::maracas::bc::vis::Visualizer

import IO;
import vis::Figure;
import vis::Render;
import Node;
import Type;
import Relation;

import lang::html5::DOM;

import org::maracas::bc::BreakingChanges;

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

str renderHtml(BreakingChanges bc) {
	kws = getKeywordParameters(bc);

	list[value] blocks = [
		h3("Statistics"),
		table(class("striped"),
			thead(tr(th("Type"), th("Count"))),
			tbody(
				[tr(td(friendlyNames[relName]), td(Relation::size(r))) |
					relName <- kws, rel[loc, Mapping[&T]] r := kws[relName]]
			)
		)
	];

	for (str relName <- kws) {
		value v = kws[relName];

		if (rel[loc, Mapping[&T]] relation := v) {
			blocks += h4(friendlyNames[relName]);
			blocks +=
				table(class("striped"),
					thead(tr(th("Old"), th("From"), th("To"), th("Score"))),
					tbody(
						[tr(td(l), td(src), td(tgt), td(score)) | <l, <src, tgt, score, _>> <- relation]
					)
				);
		}
	}

	return lang::html5::DOM::toString(
		html(
			head(
				title("BreakingChanges model between <bc.id[0].file> and <bc.id[1].file>"),
				link(\rel("stylesheet"), href("https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"))
			),
			body(
				h2("BreakingChanges model between <bc.id[0].file> and <bc.id[1].file>") +
				blocks
			)
		)
	);
}

void writeHtml(loc out, BreakingChanges bc) {
	writeFile(out, renderHtml(bc));
}

map[str, str] friendlyNames = (
	"changedAccessModifier"   : "Access modifiers changed",
	"changedFinalModifier"    : "Final modifiers changed",
	"changedStaticModifier"   : "Static modifiers changed",
	"changedAbstractModifier" : "Abstract modifiers changed",
	"deprecated"              : "Deprecated elements",
	"renamed"                 : "Renamed elements",
	"moved"                   : "Moved elements",
	"removed"                 : "Removed elements",
	"changedExtends"          : "Class extension changed",
	"changedImplements"       : "Class/Interface implementation changed",
	"changedParamList"        : "Method parameters changed",
	"changedReturnType"       : "Method return types changed",
	"changedType"             : "Field types changed"
);
