module org::maracas::delta::vis::Visualizer

import IO;
import Set;
import Node;
import Relation;
import String;
import List;

import util::Math;

import lang::html5::DOM;

import org::maracas::delta::JApiCmp;
import org::maracas::measure::delta::Evolution;
import lang::java::m3::Core;
import org::maracas::m3::Core;

list[str] colors = [
	"rgba(255,  99, 132, 0.5)",
	"rgba( 54, 162, 235, 0.5)",
	"rgba(255, 206,  86, 0.5)",
	"rgba( 75, 192, 192, 0.5)",
	"rgba(153, 102, 255, 0.5)",
	"rgba(255, 159,  64, 0.5)"
];

void writeReport(loc file, list[APIEntity] delta, loc srcV1, loc srcV2) {
	writeFile(file, renderHtml(delta, srcV1, srcV2));
}

HTML5Node statsBlock(list[APIEntity] delta) {
	map[str, value] stats = deltaStats(delta);
	stats["delta"] = "";

	return
		//table(class("striped"), HTML5Attr::style("width:auto;"),
		//	thead(tr(th("Name"), th("Value"))),
		//	tbody(
		//		[tr(td(k), td(stats[k])) | k <- stats]
		//	)
		//);
		div(p(
			""
		));
}

HTML5Node charts(list[APIEntity] delta) {
	map[str, value] stats = deltaStats(delta);
	list[str] broken = ["brokenTypes", "brokenMethods", "brokenFields"];
	list[str] changes = ["added", "removed", "modified"];
	list[str] bcs = ["bcsOnTypes", "bcsOnMethods", "bcsOnFields"];
	list[str] bcNbc = ["bcs", "changes"];

	return div(
		div(class("chart-container"), HTML5Attr::style("width:500px;height:500px;"),
			canvas(id("changes")),
			canvas(id("broken")),
			canvas(id("bcs")),
			canvas(id("bc-nbc"))
		),
		chartScript("broken", stats, broken),
		chartScript("changes", stats, changes),
		chartScript("bcs", stats, bcs),
		chartScript("bc-nbc", stats, bcNbc)
	);
}

HTML5Node chartScript(str chartId, map[str, value] stats, list[str] keys) {
	return
		script("
			new Chart(document.getElementById(\'<chartId>\'), {
				type: \'doughnut\',
				data: {
					labels: [\'<intercalate("\',\'", keys)>\'],
					datasets: [{
						data: [<intercalate(",", [stats[l] | l <- keys])>],
						backgroundColor: [\'<intercalate("\',\'", slice(colors, 0, size(keys)))>\']
					}]
				}
			});");
}

HTML5Node bcsBlock(list[APIEntity] delta, loc srcV1, loc srcV2) {
	map[CompatibilityChange, int] bcs = numberChangesPerType(delta);

	return div(
		[
			div(h4("<c> (<bcs[c]>)"),
				table(class("striped"), HTML5Attr::style("width:auto;"),
					thead(tr(th("Declaration"), th("Change"), th("V1"), th("V2"))),
					tbody(
						[tr(td(l.path), td(c), td(sourceCodeDiv(srcV1, l)), td(sourceCodeDiv(srcV2, l))) | /class(loc l, _, _, _, ch, _) := delta, c in ch, !contains(l.uri, "$") ] +
						[tr(td(l.path), td(c), td(sourceCodeDiv(srcV1, l)), td(sourceCodeDiv(srcV2, l))) | /method(loc l, _, _, _, ch, _) := delta, c in ch, !contains(l.uri, "$") ] +
						[tr(td(l.path), td(c), td(sourceCodeDiv(srcV1, l)), td(sourceCodeDiv(srcV2, l))) | /field(loc l, _, _, _, ch, _) := delta, c in ch, !contains(l.uri, "$") ]
					)
				)
			)
			| c <- bcs
		]
	);
}

HTML5Node sourceCodeDiv(loc srcDirectory, loc l) {
	list[value] firstCol = [l];
	str source = removeComments(sourceCode(srcDirectory, l));

	if (!isEmpty(source)) {
		firstCol += [br(), pre(class("prettyprint"), HTML5Attr::style("font-size:.75em;"), toHtml(source[..200] + (size(source) > 200 ? "\n[truncated]" : "")))];
	}

	return div(firstCol);
}

// yeah ok kill me
str removeComments(str src) {
	for (/<comment:\/\*[\S\s]+?\*\/>/m := src)
		src = replaceAll(src, comment, "");
	
	for (/<comment:\*.*?\*>/ := src)
		src = replaceAll(src, comment, "");

	return src;
}

str toHtml(str code) {
	return replaceAll(code, "\n", "\<br\>");
}

str renderHtml(list[APIEntity] delta, loc srcV1, loc srcV2) {
	return lang::html5::DOM::toString(html(
			head(
				title("Delta model visualizer"),
				link(\rel("stylesheet"), href("https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css")),
				script(src("https://cdn.jsdelivr.net/npm/chart.js@2.8.0")),
				script(src("https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"))
			),
			body(
				h2("Delta model visualizer"),
				h3("Statistics"),
				charts(delta),
				statsBlock(delta),
				h3("Breaking changes"),
				bcsBlock(delta, srcV1, srcV2)
			)
		)
	);
}
