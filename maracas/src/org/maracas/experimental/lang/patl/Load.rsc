module org::maracas::experimental::lang::patl::Load

import Prelude;
import org::maracas::experimental::lang::patl::Syntax;
import org::maracas::experimental::lang::patl::Abstract;


// Return the Parse Tree of the program (cf. patl::Syntax)
RuleSequence parsePATL(str content) = parse(#RuleSequence, content, allowAmbiguity=false);

// Returns the AST of the program (cf. patl::Abstract)
PATL implodePATL(str content) = implode(#PATL, parsePATL(content));