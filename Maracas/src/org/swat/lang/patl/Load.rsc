module patl::Load

import Prelude;
import patl::Syntax;
import patl::Abstract;


// Return the Parse Tree of the program (cf. patl::Syntax)
RuleSequence parsePATL(str content) = parse(#RuleSequence, content, allowAmbiguity=false);

// Returns the AST of the program (cf. patl::Abstract)
PATL implodePATL(str content) = implode(#PATL, parsePATL(content));