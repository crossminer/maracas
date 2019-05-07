module org::maracas::bc::vis::Visualizer

import IO;
import Set;
import Node;
import String;

import lang::html5::DOM;

import org::maracas::bc::BreakingChanges;
import org::maracas::m3::Core;

str renderHtml(BreakingChanges bc) {
	kws = getKeywordParameters(bc);

	list[value] blocks = [
		h3("Statistics"),
		table(class("striped"), HTML5Attr::style("width:auto;"),
			thead(tr(th("Type"), th("Count"))),
			tbody(
				[tr(td(friendlyNames[relName]), td(size(r))) |
					relName <- kws, rel[loc, Mapping[&T]] r := kws[relName]]
			)
		)
	];

	for (str relName <- kws) {
		value v = kws[relName];

		if (rel[loc, Mapping[&T]] relation := v) {
			blocks += h4(friendlyNames[relName]);
			
			if (size(relation) > 0)
				blocks +=
					table(class("striped"), HTML5Attr::style("width:auto;"),
						thead(tr(th("Old"), th("From"), th("To"), th("Score"))),
						tbody(
							[tableRow(bc, change) | change <- relation]
						)
					);
			else
				blocks += p("No changes");
		}
	}

	// Should be lang::html5::DOM::toString()
	// but see bug below
	return toString(html(
			head(
				title("BreakingChanges model between <bc.id[0].file> and <bc.id[1].file>"),
				link(\rel("stylesheet"), href("https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css")),
				script(src("https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"))
			),
			body(
				h2("BreakingChanges model between <bc.id[0].file> and <bc.id[1].file>") +
				blocks
			)
		)
	);
}

HTML5Node tableRow(BreakingChanges bc, tuple[loc, Mapping[&T]] change) {
	loc v1 = bc.id[0];
	loc v2 = bc.id[1];

	if (<l, <loc src, loc tgt, score, _>> := change)
		return tr(td(sourceCodeDiv(v1, l)), td(sourceCodeDiv(v1, src)), td(sourceCodeDiv(v2, tgt)), td(score));
	else if (<l, <src, tgt, score, _>> := change)
		return tr(td(sourceCodeDiv(v1, l)), td(src), td(tgt), td(score));

	return div();
}

HTML5Node sourceCodeDiv(loc sources, loc l) {
	list[value] firstCol = [l];
	str sourceCode = sourceCode(sources, l);

	if (!isEmpty(sourceCode)) {
		firstCol += [br(), pre(class("prettyprint"), HTML5Attr::style("font-size:.75em;"), toHtml(sourceCode[..200] + (size(sourceCode) > 200 ? "\n[truncated]" : "")))];
	}

	return div(firstCol);
}

void writeHtml(loc out, BreakingChanges bc) {
	writeFile(out, renderHtml(bc));
}

str toHtml(str code) {
	return replaceAll(code, "\n", "\<br\>");
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

/**
 * Bug: weird function overloading happening when
 * invoking renderHtml()from Java.. (between
 * Node::toString() && DOM::toString()??) resulting
 * in a complete HTML structure without any String value.
 * Copying toString() & co. from DOM here as a dirty workaround
 */
// ------------------------------------------------------
str kidsToString(list[value] kids)
  = ("" | it + kidToString(k) | k <- kids );

str kidToString(HTML5Node elt)  = toString(elt);
str kidToString(HTML5Attr x)  = "";

default str kidToString(value x)  = "<x>";

str nodeToString(str n, set[HTML5Attr] attrs, list[value] kids) {
      str s = "";
      if (isVoid(n)) {
        // ignore kids...
        s += startTag(n, attrs);
      }
      else if (isRawText(n)) {
        s += startTag(n, attrs);
        s += rawText(kids);
        s += endTag(n);
      }
      else if (isEscapableRawText(n)) {
        s += startTag(n, attrs);
        s += escapableRawText(kids);
        s += endTag(n);
      }
      else if (isBlockLevel(n)) {
        s += "<startTag(n, attrs)>
             '  <for (k <- kids) {><kidToString(k)>
             '  <}><endTag(n)>";
      }
      else {
        s += startTag(n, attrs);
        s += kidsToString(kids);
        s += endTag(n);
      }
      return s;
}

str toString(HTML5Node x) {
  attrs = { k | HTML5Attr k <- x.kids };
  kids = [ k | value k <- x.kids, HTML5Attr _ !:= k ];
  return nodeToString(x.name, attrs, kids);
}
// ------------------------------------------------------
