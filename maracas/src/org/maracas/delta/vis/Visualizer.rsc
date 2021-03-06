module org::maracas::delta::vis::Visualizer

import IO;
import Set;
import Node;
import Relation;
import String;
import List;

import util::Math;

import lang::html5::DOM;

import org::maracas::maven::Maven;

import org::maracas::delta::JApiCmp;
import org::maracas::delta::JApiCmpDetector;
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

void mavenReport(loc report, str group, str artifact, str v1, str v2,
	str cgroup = "", str cartifact = "", str cv = "") {
	println("Building report for <group>:<artifact> (<v1> -\> <v2>)...");

	if (!isDirectory(report))
		mkDirectory(report);

	bool detects = !isEmpty(cgroup) && !isEmpty(cartifact) && !isEmpty(cv);
	set[Detection] ds = {};
	loc srcClient = |tmp:///|; 

	println("Downloading JARs and extracting sources in <report>...");
	loc jarV1 = downloadJar(group, artifact, v1, report);
	loc jarV2 = downloadJar(group, artifact, v2, report);
	loc srcJarV1 = downloadSources(group, artifact, v1, report);
	loc srcJarV2 = downloadSources(group, artifact, v2, report);
	loc srcV1 = extractJar(srcJarV1, report + "<artifact>-<v1>-extracted");
	loc srcV2 = extractJar(srcJarV2, report + "<artifact>-<v2>-extracted");
	
	println("Computing delta...");
	list[APIEntity] delta = compareJars(jarV1, jarV2, v1, v2);

	if (detects) {
		loc clientJar = downloadJar(cgroup, cartifact, cv, report);
		loc srcJarClient = downloadSources(cgroup, cartifact, cv, report);
		srcClient = extractJar(srcJarClient, report + "<cartifact>-<cv>-extracted");

		println("Computing M3 for detections...");
		M3 clientM3 = createM3(clientJar);
		M3 v1m3 = createM3(jarV1);
		M3 v2m3 = createM3(jarV2);
		Evolution evol = evolution(clientM3, v1m3, v2m3, delta);
		
		println("Computing detections...");
		ds = computeDetections(evol);
	}

	println("Writing report...");
	writeFile(report + "Report.html", renderHtml(delta, ds, srcV1, srcV2, srcClient));
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

HTML5Node charts(list[APIEntity] delta, str suffix) {
	map[str, value] stats = deltaStats(delta);

	list[str] broken = ["brokenTypes", "brokenMethods", "brokenFields"];
	list[str] changes = ["added", "removed", "modified"];
	list[str] bcs = ["bcsOnTypes", "bcsOnMethods", "bcsOnFields"];
	list[str] bcNbc = ["bcs", "changes", "deprecated"];
	list[str] bcTypes = [ getName(k) | k <- numberChangesPerType(delta) ];

	return div(
		div(class("chart-container"),
			div(class("canvas-holder-large"), canvas(id("bc-types-<suffix>"))),
			div(class("canvas-holder"), canvas(id("bc-nbc-<suffix>"))),
			div(class("canvas-holder"), canvas(id("changes-<suffix>"))),
			div(class("canvas-holder"), canvas(id("broken-<suffix>"))),
			div(class("canvas-holder"), canvas(id("bcs-<suffix>")))
		),
		div(style("clear:both;")),
		chartScript("bc-types-<suffix>", stats, bcTypes),
		chartScript("bc-nbc-<suffix>", stats, bcNbc),
		chartScript("broken-<suffix>", stats, broken),
		chartScript("changes-<suffix>", stats, changes),
		chartScript("bcs-<suffix>", stats, bcs)
	);
}

HTML5Node chartScript(str chartId, map[str, value] stats, list[str] keys, str chartType = "bar", str dtLabel = "Count") {
	return
		script("
			new Chart(document.getElementById(\'<chartId>\'), {
				type: \'<chartType>\',
				data: {
					labels: [\'<intercalate("\',\'", keys)>\'],
					datasets: [{
						label: \'<dtLabel>\',
						data: [<intercalate(",", [stats[l] | l <- keys])>],
						backgroundColor: [\'<intercalate("\',\'", slice(colors, 0, size(keys) % size(colors)))>\']
					}]
				}
			});");
}

HTML5Node bcsBlock(list[APIEntity] delta, loc srcV1, loc srcV2) {
	map[CompatibilityChange, int] bcs = numberChangesPerType(delta);

	return div(
		[
			div(h4("<getName(c)> (<bcs[c]>)"),
				table(class("striped"),
					thead(tr(th("Declaration"), th("Change"), th("V1"), th("V2"))),
					tbody(
						[tr(td(l.path), td(getName(c)), sourceCodeCell(srcV1, l), sourceCodeCell(srcV2, l)) | /class(loc l, _, _, _, _, ch, _) := delta, c in ch ] +
						[tr(td(l.path), td(getName(c)), sourceCodeCell(srcV1, l), sourceCodeCell(srcV2, l)) | /method(loc l, _, _, _, ch, _) := delta, c in ch ] +
						[tr(td(l.path), td(getName(c)), sourceCodeCell(srcV1, l), sourceCodeCell(srcV2, l)) | /field(loc l, _, _, _, ch, _) := delta, c in ch ] +
						[tr(td(l.path), td(getName(c)), sourceCodeCell(srcV1, l), sourceCodeCell(srcV2, l)) | /interface(loc l, ch, _) := delta, c in ch ] +
						[tr(td(l.path), td(getName(c)), sourceCodeCell(srcV1, l), sourceCodeCell(srcV2, l)) | /constructor(loc l, _, _, ch, _) := delta, c in ch ] +
						[tr(td(l.path), td(getName(c)), sourceCodeCell(srcV1, l), sourceCodeCell(srcV2, l)) | /annotation(loc l, _, ch, _) := delta, c in ch ] +
						[tr(td(super), td(getName(c)), td(), td()) | /superclass(ch, super) := delta, c in ch]
					)
				)
			)
			| c <- bcs
		]
	);
}

HTML5Node detectionsBlock(set[Detection] ds, loc srcV1, loc srcClient) {
	return div(h4("Detections (<size(ds)>)"),
		table(class("striped"),
			thead(tr(th("Client"), th("API"), th("Use"), th("Change"))),
			tbody(
				[tr(sourceCodeCell(srcClient, d.elem), sourceCodeCell(srcV1, d.used), td(d.use), td(d.change)) | d <- ds]
			)
		)
	);
}

HTML5Node sourceCodeCell(loc srcDirectory, loc l) {
	list[value] firstCol = [l];
	str source = trim(removeComments(sourceCode(srcDirectory, l)));

	if (!isEmpty(source)) {
		firstCol += [br(), pre(class("prettyprint"), HTML5Attr::style("font-size:.75em;"), toHtml(source[..200] + (size(source) > 200 ? "\n[truncated]" : "")))];
	}

	return td(firstCol);
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

str renderHtml(list[APIEntity] delta, set[Detection] detections, loc srcV1, loc srcV2, loc srcClient) {
	return lang::html5::DOM::toString(html(
			head(
				title("Delta model visualizer"),
				link(\rel("stylesheet"), href("https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css")),
				script(src("https://cdn.jsdelivr.net/npm/chart.js@2.8.0")),
				script(src("https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js")),
				style("
					.canvas-holder { width:20%; float:left; }
					.canvas-holder-large { width:50%; float:left; clear:both; }
					h3 { clear:both; }
					.striped td, .striped th { display:inline-block;width:25%;word-wrap:break-word; }
					pre {
					    white-space: pre-wrap;       /* Since CSS 2.1 */
					    white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
					    white-space: -pre-wrap;      /* Opera 4-6 */
					    white-space: -o-pre-wrap;    /* Opera 7 */
					    word-wrap: break-word;       /* Internet Explorer 5.5+ */
					}
				")
			),
			body(
				h2("Delta model visualizer"),
				h3("Statistics"),
				charts(delta, "all"),
				h3("Statistics (stable API only)"),
				charts(filterStableAPIByAnnon(delta), "stable"),
				statsBlock(delta),
				h3("Breaking changes"),
				bcsBlock(delta, srcV1, srcV2),
				h3("Detections"),
				detectionsBlock(detections, srcV1, srcClient)
			)
		)
	);
}
